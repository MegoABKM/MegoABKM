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
  TextEditingController? insideTextField;
  TextEditingController? insideTitleField;
  Uint8List? drawingBytes;

  SqlDb sqlDb = SqlDb();

  int? selectedCategoryId;
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool isDrawingMode = false;
  Timer? _debounceTimer;

  void toggleDrawingMode() {
    isDrawingMode = !isDrawingMode;
    update();
  }

  void saveContent(String value) {
    note = UserNotesModel(
      id: note?.id,
      title: note?.title,
      content: value,
      date: note?.date,
      drawing: note?.drawing,
      categoryId: selectedCategoryId?.toString(),
    );
    // Debounce the update
    _debounceUpdate();
  }

  void saveTitle(String value) {
    note = UserNotesModel(
      id: note?.id,
      title: value,
      content: note?.content,
      date: note?.date,
      drawing: note?.drawing,
      categoryId: selectedCategoryId?.toString(),
    );
    // Debounce the update
    _debounceUpdate();
  }

  void _debounceUpdate() {
    // Cancel any existing timer
    _debounceTimer?.cancel();
    // Start a new timer to update after 500ms of inactivity
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      updateData();
    });
  }

  Future<void> updateData() async {
    if (note == null || note!.id == null) {
      print("Error: Note or note ID is null");
      update();
      return;
    }

    // Prevent saving notes with minimal content
    if ((note!.title?.isEmpty ?? true) &&
        (note!.content?.isEmpty ?? true) &&
        (note!.drawing?.isEmpty ?? true)) {
      print("Skipping update: Note is empty");
      return;
    }

    update();

    final drawingBase64 = await getDrawingAsBase64();

    final updatedNote = UserNotesModel(
      id: note!.id,
      title: insideTitleField?.text ?? note!.title,
      content: insideTextField?.text ?? note!.content,
      date: note!.date,
      drawing: drawingBase64 ?? note!.drawing,
      categoryId: selectedCategoryId?.toString(),
    );

    try {
      final response = await sqlDb.updateData(
        "UPDATE notes SET title = ?, content = ?, drawing = ?, categoryId = ? WHERE id = ?",
        [
          updatedNote.title!.isEmpty ? 'Untitled' : updatedNote.title,
          updatedNote.content,
          updatedNote.drawing,
          updatedNote.categoryId,
          updatedNote.id,
        ],
      );

      if (response > 0) {
        note = updatedNote;
        drawingBytes =
            updatedNote.drawing != null && updatedNote.drawing!.isNotEmpty
                ? base64Decode(updatedNote.drawing!)
                : null;
        Get.find<HomeController>().getNoteData();
        print("Note updated successfully");
      } else {
        print("Failed to update note");
      }
    } catch (e) {
      print("Error updating note: $e");
    }

    update();
  }

  void loadNoteData() {
    insideTextField!.text = note!.content ?? "";
    insideTitleField!.text = note!.title ?? "";
    if (note!.drawing != null && note!.drawing!.isNotEmpty) {
      drawingBytes = base64Decode(note!.drawing!);
      signatureController.clear();
    }
    selectedCategoryId =
        note!.categoryId != null ? int.tryParse(note!.categoryId!) : null;
    update();
  }

  Future<String?> getDrawingAsBase64() async {
    if (signatureController.isNotEmpty) {
      final bytes = await signatureController.toPngBytes();
      return bytes != null ? base64Encode(bytes) : null;
    }
    return note?.drawing;
  }

  @override
  void onInit() {
    super.onInit();
    note = Get.arguments['note'] as UserNotesModel?;
    insideTextField = TextEditingController();
    insideTitleField = TextEditingController();
    if (note != null) {
      loadNoteData();
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    insideTextField?.dispose();
    insideTitleField?.dispose();
    signatureController.dispose();
    super.onClose();
  }
}
