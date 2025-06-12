import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateStudentDetailsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // Student fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController stageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bornController = TextEditingController();

  // Guardian fields
  final TextEditingController guardianFullNameController =
      TextEditingController();
  final TextEditingController guardianPhoneNumberController =
      TextEditingController();
  final TextEditingController guardianBornController = TextEditingController();
  final TextEditingController guardianCountryController =
      TextEditingController();
  final TextEditingController guardianCityController = TextEditingController();
  final TextEditingController guardianNeighborhoodController =
      TextEditingController();
  final TextEditingController guardianStreetNameController =
      TextEditingController();
  final TextEditingController guardianBuildNumberController =
      TextEditingController();

  var student = Rx<Map<String, dynamic>>({});
  var guardian = Rx<Map<String, dynamic>>({});
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    student.value = Get.arguments['student'] as Map<String, dynamic>;
    loadStudentData();
    fetchGuardianData();
  }

  void loadStudentData() {
    firstNameController.text = student.value['student_firstname'] ?? '';
    lastNameController.text = student.value['student_lastname'] ?? '';
    ageController.text = student.value['student_age']?.toString() ?? '';
    stageController.text = student.value['student_stage'] ?? '';
    emailController.text = student.value['student_email'] ?? '';
    phoneNumberController.text = student.value['student_phonenumber'] ?? '';
    bornController.text = student.value['student_born'] ?? '';
  }

  Future<void> fetchGuardianData() async {
    isLoading.value = true;
    try {
      final guardianId = student.value['student_gaurdianid'];
      if (guardianId == null) {
        print('No guardian ID found for student');
        guardian.value = {};
        return;
      }

      print('Fetching guardian data for gaurdian_id: $guardianId');
      final response = await supabase
          .from('gaurdian') // Matches your typo
          .select('*')
          .eq('gaurdian_id', guardianId)
          .single();

      guardian.value = response;
      guardianFullNameController.text =
          guardian.value['gaurdian_fullname'] ?? '';
      guardianPhoneNumberController.text =
          guardian.value['gaurdian_phonenumber'] ?? '';
      guardianBornController.text = guardian.value['gaurdian_born'] ?? '';
      guardianCountryController.text = guardian.value['gaurdian_country'] ?? '';
      guardianCityController.text = guardian.value['gaurdian_city'] ?? '';
      guardianNeighborhoodController.text =
          guardian.value['gaurdian_neighberhood'] ?? '';
      guardianStreetNameController.text =
          guardian.value['gaurdian_streetname'] ?? '';
      guardianBuildNumberController.text =
          guardian.value['gaurdian_buildnumber'] ?? '';
      print('Guardian info loaded: ${guardian.value}');
    } catch (e) {
      print('Error fetching guardian data: $e');
      guardian.value = {};
      Get.snackbar('خطأ', 'فشل في جلب معلومات ولي الأمر: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStudent() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      // Update student
      print('Updating student with ID: ${student.value['student_id']}');
      await supabase.from('student').update({
        'student_firstname': firstNameController.text,
        'student_lastname': lastNameController.text,
        'student_age': int.tryParse(ageController.text) ?? 0,
        'student_stage': stageController.text,
        'student_email': emailController.text,
        'student_phonenumber': phoneNumberController.text,
        'student_born': bornController.text,
        'student_schoolid': schoolId,
      }).eq('student_id', student.value['student_id']);

      if (student.value['student_gaurdianid'] != null) {
        print(
            'Updating guardian with ID: ${student.value['student_gaurdianid']}');
        await supabase.from('gaurdian').update({
          'gaurdian_fullname': guardianFullNameController.text,
          'gaurdian_phonenumber': guardianPhoneNumberController.text,
          'gaurdian_born': guardianBornController.text,
          'gaurdian_country': guardianCountryController.text,
          'gaurdian_city': guardianCityController.text,
          'gaurdian_neighberhood': guardianNeighborhoodController.text,
          'gaurdian_streetname': guardianStreetNameController.text,
          'gaurdian_buildnumber': guardianBuildNumberController.text,
        }).eq('gaurdian_id', student.value['student_gaurdianid']);
      }

      print('Student and guardian updated successfully');
      Get.snackbar('نجاح', 'تم تحديث بيانات الطالب وولي الأمر بنجاح');
      Get.back(); // Navigate back to UpdateStudentScreen
    } catch (e) {
      print('Error updating student or guardian: $e');
      Get.snackbar('خطأ', 'فشل في تحديث البيانات: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    stageController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    bornController.dispose();
    guardianFullNameController.dispose();
    guardianPhoneNumberController.dispose();
    guardianBornController.dispose();
    guardianCountryController.dispose();
    guardianCityController.dispose();
    guardianNeighborhoodController.dispose();
    guardianStreetNameController.dispose();
    guardianBuildNumberController.dispose();
    super.onClose();
  }
}
