// lib/controller/schoolmanagment/teachermanagement/subjecmanagement/tablemanagement/updatetimetable_controller.dart
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/tablemanagement/viewtimetable_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/core/class/timetableentry.dart';
import 'package:schoolmanagement/main.dart';

class EditTimetableController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  RxList<TimetableEntryCreate> timetableEntries = <TimetableEntryCreate>[].obs;
  RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  Rx<int?> selectedSubjectId = Rx<int?>(null);
  Rx<String?> selectedDay = Rx<String?>(null);
  Rx<String?> selectedTimeSlot = Rx<String?>(null);
  Rx<int?> classId = Rx<int?>(null);
  var isLoading = false.obs;

  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final List<String> timeSlots = [
    '8:00-9:00',
    '9:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '12:00-13:00'
  ];

  EditTimetableController({int? classId}) {
    this.classId.value = classId;
  }

  @override
  void onInit() {
    super.onInit();
    if (classId.value == null) {
      Get.snackbar('خطأ', 'لم يتم تحديد الصف');
      Get.back();
      return;
    }
    fetchSubjects();
    fetchExistingTimetable();
  }

  Future<void> fetchSubjects() async {
    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final response = await supabase
          .from('subjects')
          .select('subject_id, subject_name')
          .eq('school_id', schoolId);

      subjects.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching subjects: $e');
      Get.snackbar('خطأ', 'فشل في جلب المواد: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExistingTimetable() async {
    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final response = await supabase
          .from('timetable')
          .select('timetable_id, subjects(subject_name), day, time_slot')
          .eq('school_id', schoolId)
          .eq('class_id', classId.value!);

      timetableEntries.value = (response as List).map((row) {
        return TimetableEntryCreate(
          row['subjects']['subject_name'],
          row['time_slot'],
          row['day'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching timetable: $e');
      Get.snackbar('خطأ', 'فشل في جلب الجدول: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void addOrUpdateEntry() {
    if (selectedSubjectId.value == null ||
        selectedDay.value == null ||
        selectedTimeSlot.value == null) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الحقول');
      return;
    }

    final subject =
        subjects.firstWhere((s) => s['subject_id'] == selectedSubjectId.value);
    updateOrAddEntry(
        subject['subject_name'], selectedTimeSlot.value!, selectedDay.value!);
    resetFields();
    Get.snackbar('نجاح', 'تمت إضافة/تحديث المادة في الجدول');
  }

  void updateOrAddEntry(String subjectName, String timeSlot, String day) {
    final existingIndex = timetableEntries
        .indexWhere((e) => e.timeSlot == timeSlot && e.day == day);
    if (existingIndex != -1) {
      timetableEntries[existingIndex] =
          TimetableEntryCreate(subjectName, timeSlot, day);
    } else {
      if (timetableEntries.any((e) => e.timeSlot == timeSlot && e.day == day)) {
        Get.snackbar('خطأ', 'يوجد مادة أخرى في نفس الوقت واليوم');
        return;
      }
      timetableEntries.add(TimetableEntryCreate(subjectName, timeSlot, day));
    }
    timetableEntries.refresh();
  }

  Future<void> updateTimetableInDatabase() async {
    if (timetableEntries.isEmpty) {
      Get.snackbar('خطأ', 'لا توجد مواد للحفظ');
      return;
    }

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      // Delete existing timetable for this class
      await supabase.from('timetable').delete().eq('class_id', classId.value!);

      // Insert updated timetable
      final data = timetableEntries.map((entry) {
        return {
          'subject_id': subjects.firstWhere(
              (s) => s['subject_name'] == entry.subjectName)['subject_id'],
          'day': entry.day,
          'time_slot': entry.timeSlot,
          'school_id': int.parse(schoolId),
          'class_id': classId.value,
        };
      }).toList();

      await supabase.from('timetable').insert(data);
      Get.snackbar('نجاح', 'تم تحديث الجدول في قاعدة البيانات');
      Get.back();
      Get.find<ViewTimetableController>().fetchTimetable(); // Refresh view
    } catch (e) {
      print('Error updating timetable: $e');
      Get.snackbar('خطأ', 'فشل في تحديث الجدول: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String getSubjectForSlot(String timeSlot, String day) {
    final entry = timetableEntries
        .firstWhereOrNull((e) => e.timeSlot == timeSlot && e.day == day);
    return entry?.subjectName ?? '';
  }

  void resetFields() {
    selectedSubjectId.value = null;
    selectedDay.value = null;
    selectedTimeSlot.value = null;
  }
}
