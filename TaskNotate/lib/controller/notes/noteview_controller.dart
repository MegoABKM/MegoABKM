import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';

class NoteviewController extends GetxController {
  UserNotesModel? note;
  late TextEditingController insideTextField; // Make late, initialize in onInit
  late TextEditingController
      insideTitleField; // Make late, initialize in onInit
  Uint8List? drawingBytes;

  SqlDb sqlDb = SqlDb();

  int? selectedCategoryId;
  // --- MODIFIED: SignatureController will be initialized in onInit ---
  late SignatureController signatureController;
  // --- END MODIFIED ---

  bool isDrawingMode = false;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    // --- MODIFIED: Initialize controllers here ---
    insideTextField = TextEditingController();
    insideTitleField = TextEditingController();
    signatureController = SignatureController(
      // Create a new instance
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    // --- END MODIFIED ---

    // Robust argument handling
    final arguments = Get.arguments;
    if (arguments != null &&
        arguments is Map &&
        arguments.containsKey('note')) {
      note = arguments['note'] as UserNotesModel?;
    } else {
      // Fallback if arguments are not as expected or note is not passed
      print(
          "NoteView: Note argument not found or invalid. Navigating back or showing error.");
      // Example: Navigate back if note is essential for this view
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Get.offAllNamed(AppRoute.home);
      // });
      // Or set note to a default empty state if applicable, though usually view needs a specific note.
      // For now, we'll proceed, and the UI should handle note == null
    }

    if (note != null) {
      loadNoteData();
    } else {
      print("NoteView: Note is null after argument check in onInit!");
      // Potentially show an error or navigate back immediately
    }
  }

  void toggleDrawingMode() {
    isDrawingMode = !isDrawingMode;
    if (isDrawingMode) {
      // When entering drawing mode:
      signatureController
          .clear(); // Always clear for a fresh start or to load existing
      if (drawingBytes != null && drawingBytes!.isNotEmpty) {
        // If you want to allow editing the existing drawing, you'd convert
        // drawingBytes (which is PNG) back to SignaturePoint data.
        // This is complex and the `signature` package doesn't directly support
        // loading from PNG bytes back into editable points easily.
        // For now, clearing means new drawing starts over the displayed image.
        // Or, you might decide drawing mode is always for NEW drawings on this screen.
        print(
            "Entering drawing mode. Previous drawing displayed, canvas cleared for new input.");
      }
    }
    update();
  }

  void saveContent(String value) {
    if (note == null) return;
    // Ensure title is also captured from its controller if it changed
    note = note!.copyWith(content: value, title: insideTitleField.text);
    _debounceUpdate();
  }

  void saveTitle(String value) {
    if (note == null) return;
    // Ensure content is also captured
    note = note!.copyWith(title: value, content: insideTextField.text);
    _debounceUpdate();
  }

  void _debounceUpdate() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      updateData();
    });
  }

  Future<void> updateData() async {
    if (note == null || note!.id == null) {
      print("Error: Note or note ID is null in updateData (View)");
      return;
    }

    String titleToSave =
        insideTitleField.text; // Get current text from controller
    String contentToSave =
        insideTextField.text; // Get current text from controller
    String? drawingToSave = note!.drawing;

    if (isDrawingMode && signatureController.isNotEmpty) {
      drawingToSave = await getDrawingAsBase64();
    } else if (isDrawingMode &&
        signatureController.isEmpty &&
        drawingBytes != null) {
      // If user entered drawing mode, cleared the canvas, and there was an old drawing
      drawingToSave = null; // Means the drawing was cleared
    }

    // Prevent saving effectively empty notes if all fields are cleared
    if (titleToSave.isEmpty &&
        contentToSave.isEmpty &&
        (drawingToSave == null || drawingToSave.isEmpty)) {
      print("Skipping update: Note is effectively empty (View)");
      // You might want to delete it from DB here if an existing note becomes empty
      // await sqlDb.deleteData("DELETE FROM notes WHERE id = ?", [note!.id]);
      // Get.find<HomeController>().getNoteData();
      // Get.offAllNamed(AppRoute.home); // Navigate away
      return;
    }

    final updatedNote = UserNotesModel(
      id: note!.id,
      title: titleToSave,
      content: contentToSave,
      date: note!.date,
      drawing: drawingToSave,
      categoryId: selectedCategoryId?.toString(),
    );

    try {
      final response = await sqlDb.updateData(
        "UPDATE notes SET title = ?, content = ?, drawing = ?, categoryId = ? WHERE id = ?",
        [
          updatedNote.title,
          updatedNote.content,
          updatedNote.drawing,
          updatedNote.categoryId,
          updatedNote.id,
        ],
      );

      if (response > 0) {
        note = updatedNote;
        if (updatedNote.drawing != null && updatedNote.drawing!.isNotEmpty) {
          drawingBytes = base64Decode(updatedNote.drawing!);
        } else {
          drawingBytes = null; // Drawing was cleared or never existed
        }
        Get.find<HomeController>().getNoteData();
        print("Note updated successfully (View)");
      } else {
        print("Failed to update note (View)");
      }
    } catch (e) {
      print("Error updating note (View): $e");
    }
    update();
  }

  void loadNoteData() {
    if (note == null) return;
    insideTitleField.text = note!.title ?? "";
    insideTextField.text = note!.content ?? "";

    if (note!.drawing != null && note!.drawing!.isNotEmpty) {
      try {
        drawingBytes = base64Decode(note!.drawing!);
      } catch (e) {
        print("Error decoding drawing in loadNoteData: $e");
        drawingBytes = null;
      }
    } else {
      drawingBytes = null;
    }
    // It's important that signatureController is fresh if we intend to draw/edit.
    // If simply viewing, we show drawingBytes. If editing, canvas should be clear or load points.
    signatureController.clear();
    selectedCategoryId =
        note!.categoryId != null ? int.tryParse(note!.categoryId!) : null;
    update();
  }

  Future<String?> getDrawingAsBase64() async {
    if (signatureController.points.isNotEmpty) {
      // Check points directly
      final bytes = await signatureController.toPngBytes();
      return bytes != null ? base64Encode(bytes) : null;
    }
    // If currently in drawing mode and controller is empty, it means user cleared it or didn't draw
    // So, if we are saving from drawing mode, an empty canvas means no drawing.
    if (isDrawingMode) return null;

    // Otherwise, return the existing drawing (if not in drawing mode)
    return note?.drawing;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    // Attempt a final save only if a note was loaded and potentially modified
    if (note != null && note!.id != null) {
      bool titleChanged = insideTitleField.text != (note!.title ?? "");
      bool contentChanged = insideTextField.text != (note!.content ?? "");
      // A more robust check for drawing changes would be needed if directly editing existing points.
      // For now, if isDrawingMode was active and something was drawn, it should have been captured.
      if (titleChanged ||
          contentChanged ||
          (isDrawingMode && signatureController.isNotEmpty)) {
        // updateData(); // Calling async here can be tricky in onClose
        print(
            "NoteView onClose: Potential unsaved changes. Consider manual save button or different UX.");
      }
    }

    insideTextField.dispose();
    insideTitleField.dispose();
    signatureController.dispose(); // Dispose the dynamically created controller
    super.onClose();
  }
}
