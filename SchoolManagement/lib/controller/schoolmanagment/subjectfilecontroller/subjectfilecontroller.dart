import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectFilesController extends GetxController {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> subjects = [];
  List<Map<String, dynamic>> files = [];
  String? selectedSubjectId;

  RxBool isUploading = false.obs;
  RxString uploadStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    try {
      final response = await supabase.from('subjects').select();
      print('Fetched subjects: $response');
      subjects = List<Map<String, dynamic>>.from(response);
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب المواد: $e');
    }
  }

  Future<void> fetchFiles(String subjectId) async {
    try {
      final response =
          await supabase.from('files').select().eq('subject_id', subjectId);
      print('Fetched files for subject $subjectId: $response');
      files = List<Map<String, dynamic>>.from(response);
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الملفات: $e');
    }
  }

  Future<void> uploadFile(String subjectId) async {
    try {
      isUploading.value = true;
      uploadStatus.value = 'جاري الرفع...';

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'pptx', 'png', 'jpg', 'jpeg'],
      );

      if (result == null || result.files.isEmpty) {
        isUploading.value = false;
        uploadStatus.value = 'فشل في الرفع: لم يتم اختيار ملف';
        Get.snackbar('خطأ', 'لم يتم اختيار ملف');
        return;
      }

      final platformFile = result.files.single;
      if (platformFile.path == null) {
        isUploading.value = false;
        uploadStatus.value = 'فشل في الرفع: مسار الملف غير متوفر';
        Get.snackbar('خطأ', 'مسار الملف غير متوفر');
        return;
      }

      File file = File(platformFile.path!);
      String fileName = platformFile.name;
      String fileType = fileName.split('.').last;

      print('Uploading file: $fileName to subject $subjectId');
      await supabase.storage
          .from('subjectfiles')
          .upload('$subjectId/$fileName', file);

      await supabase.from('files').insert({
        'subject_id': subjectId,
        'file_name': fileName,
        'file_path': '$subjectId/$fileName',
        'file_type': fileType,
      });

      await fetchFiles(subjectId);

      isUploading.value = false;
      uploadStatus.value = 'تم الرفع بنجاح';
      Get.snackbar('نجاح', 'تم رفع الملف بنجاح');
    } catch (e) {
      isUploading.value = false;
      uploadStatus.value = 'فشل في الرفع: $e';
      Get.snackbar('خطأ', 'فشل في رفع الملف');
      print('Upload error: $e');
    }
  }

  Future<void> deleteFile(String fileId, String filePath) async {
    try {
      await supabase.storage.from('subjectfiles').remove([filePath]);
      await supabase.from('files').delete().eq('id', fileId);
      files.removeWhere((file) => file['id'].toString() == fileId);
      update();
      Get.snackbar('نجاح', 'تم حذف الملف بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف الملف: $e');
    }
  }

  String getDownloadUrl(String filePath) {
    return supabase.storage.from('subjectfiles').getPublicUrl(filePath);
  }

  void onSubjectSelected(String? subjectId) {
    print('Selected subject ID: $subjectId');
    selectedSubjectId = subjectId;
    if (subjectId != null) {
      fetchFiles(subjectId);
    } else {
      files.clear();
      update();
    }
  }
}
