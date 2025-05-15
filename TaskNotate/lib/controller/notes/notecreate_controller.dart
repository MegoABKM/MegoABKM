import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';
import 'package:tasknotate/controller/home_controller.dart';

class NotecreateController extends GetxController {
  TextEditingController? titleController;
  TextEditingController? insideTextField;
  int? selectedCategoryId;
  SqlDb sqlDb = SqlDb();

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool isDrawingMode = false;
  UserNotesModel? currentNote;
  int? lastInsertedId;

  Timer? _debounceTimer;

  void toggleDrawingMode() {
    isDrawingMode = !isDrawingMode;
    update();
  }

  Future<String?> getDrawingAsBase64() async {
    if (signatureController.isNotEmpty) {
      final bytes = await signatureController.toPngBytes();
      return bytes != null ? base64Encode(bytes) : null;
    }
    return currentNote?.drawing;
  }

  void saveTitle(String value) {
    // Update currentNote without immediate upload
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: value,
      content: currentNote?.content ?? '',
      date: currentNote?.date ?? DateTime.now().toIso8601String(),
      drawing: currentNote?.drawing ?? '',
      categoryId: selectedCategoryId?.toString(),
    );
    // Debounce the upload
    _debounceUpload();
  }

  void saveContent(String value) {
    // Update currentNote without immediate upload
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: currentNote?.title ?? titleController?.text ?? '',
      content: value,
      date: currentNote?.date ?? DateTime.now().toIso8601String(),
      drawing: currentNote?.drawing ?? '',
      categoryId: selectedCategoryId?.toString(),
    );
    // Debounce the upload
    _debounceUpload();
  }

  void updateNoteCategory() {
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: currentNote?.title ?? titleController?.text ?? '',
      content: currentNote?.content ?? '',
      date: currentNote?.date ?? DateTime.now().toIso8601String(),
      drawing: currentNote?.drawing ?? '',
      categoryId: selectedCategoryId?.toString(),
    );
    uploadData();
  }

  void _debounceUpload() {
    // Cancel any existing timer
    _debounceTimer?.cancel();
    // Start a new timer to upload after 500ms of inactivity
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      uploadData();
    });
  }

  Future<void> uploadData() async {
    if (currentNote == null) {
      print("Error: currentNote is null");
      update();
      return;
    }

    // Prevent saving notes with minimal content
    if ((currentNote!.title?.isEmpty ?? true) &&
        (currentNote!.content?.isEmpty ?? true) &&
        (currentNote!.drawing?.isEmpty ?? true)) {
      print("Skipping upload: Note is empty");
      return;
    }

    update();

    final drawingBase64 = await getDrawingAsBase64();

    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: currentNote!.title!.isEmpty ? 'Untitled' : currentNote!.title,
      content: currentNote!.content,
      date: currentNote!.date,
      drawing: drawingBase64 ?? currentNote!.drawing,
      categoryId: selectedCategoryId?.toString(),
    );

    try {
      if (lastInsertedId == null) {
        final response = await sqlDb.insertData(
          "INSERT INTO notes (title, content, date, drawing, categoryId) VALUES (?, ?, ?, ?, ?)",
          [
            currentNote!.title,
            currentNote!.content,
            currentNote!.date,
            currentNote!.drawing,
            currentNote!.categoryId,
          ],
        );

        if (response > 0) {
          lastInsertedId = response;
          Get.find<HomeController>().getNoteData();
          print("Note created successfully with ID: $lastInsertedId");
        } else {
          print("Failed to create note");
        }
      } else {
        final response = await sqlDb.updateData(
          "UPDATE notes SET title = ?, content = ?, drawing = ?, categoryId = ? WHERE id = ?",
          [
            currentNote!.title,
            currentNote!.content,
            currentNote!.drawing,
            currentNote!.categoryId,
            lastInsertedId,
          ],
        );

        if (response > 0) {
          Get.find<HomeController>().getNoteData();
          print("Note updated successfully");
        } else {
          print("Failed to update note");
        }
      }
    } catch (e) {
      print("Error uploading note: $e");
    }

    update();
  }

  @override
  void onInit() {
    titleController = TextEditingController();
    insideTextField = TextEditingController();
    currentNote = UserNotesModel(
      title: '',
      content: '',
      date: DateTime.now().toIso8601String(),
      drawing: '',
    );
    super.onInit();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    titleController?.dispose();
    insideTextField?.dispose();
    signatureController.dispose();
    super.onClose();
  }
}
