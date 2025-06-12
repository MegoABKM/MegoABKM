// lib/controllers/timetable_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/core/class/timetableentry.dart';
import 'package:schoolmanagement/main.dart';

class CreateTimetableController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  RxList<TimetableEntryCreate> timetableEntries = <TimetableEntryCreate>[].obs;
  RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;
  Rx<int?> selectedSubjectId = Rx<int?>(null);
  Rx<String?> selectedDay = Rx<String?>(null);
  Rx<String?> selectedTimeSlot = Rx<String?>(null);
  Rx<int?> selectedClassId = Rx<int?>(null);
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

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
    fetchClasses();
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

  Future<void> fetchClasses() async {
    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final response = await supabase
          .from('class')
          .select('class_id, class_name, stage')
          .eq('school_id', schoolId);

      classes.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching classes: $e');
      Get.snackbar('خطأ', 'فشل في جلب الفصول: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void addTimetableEntry() {
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
    Get.snackbar('نجاح', 'تمت إضافة المادة إلى الجدول');
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

  Future<void> uploadToDatabase() async {
    if (timetableEntries.isEmpty) {
      Get.snackbar('خطأ', 'لا توجد مواد للحفظ');
      return;
    }
    if (selectedClassId.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الصف قبل الحفظ');
      return;
    }

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final data = timetableEntries.map((entry) {
        return {
          'subject_id': subjects.firstWhere(
              (s) => s['subject_name'] == entry.subjectName)['subject_id'],
          'day': entry.day,
          'time_slot': entry.timeSlot,
          'school_id': int.parse(schoolId),
          'class_id': selectedClassId.value, // Replaced stage_id with class_id
        };
      }).toList();

      await supabase.from('timetable').insert(data);
      Get.snackbar('نجاح', 'تم حفظ الجدول في قاعدة البيانات');
      timetableEntries.clear();
      selectedClassId.value = null;
    } catch (e) {
      print('Error uploading to Supabase: $e');
      Get.snackbar('خطأ', 'فشل في حفظ الجدول: ${e.toString()}');
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
