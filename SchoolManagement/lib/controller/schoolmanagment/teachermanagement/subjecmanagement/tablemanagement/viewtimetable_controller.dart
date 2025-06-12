// lib/controllers/view_timetable_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/core/class/timetableentry.dart';
import 'package:schoolmanagement/main.dart';

class ViewTimetableController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  RxList<TimetableEntry> timetableEntries = <TimetableEntry>[].obs;
  RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;
  Rx<int?> selectedStageId = Rx<int?>(null);
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
    fetchClasses();
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

  Future<void> fetchTimetable() async {
    if (selectedClassId.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الصف');
      return;
    }

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
          .eq('class_id', selectedClassId.value!);

      timetableEntries.value = (response as List).map((row) {
        return TimetableEntry(
          row['timetable_id'],
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

  void setStage(int stageId) {
    selectedStageId.value = stageId;
    selectedClassId.value = null; // Reset class selection
    timetableEntries.clear(); // Clear timetable until class is selected
  }

  void setClass(int classId) {
    selectedClassId.value = classId;
    fetchTimetable();
  }

  String getSubjectForSlot(String timeSlot, String day) {
    final entry = timetableEntries
        .firstWhereOrNull((e) => e.timeSlot == timeSlot && e.day == day);
    return entry?.subjectName ?? '';
  }
}
