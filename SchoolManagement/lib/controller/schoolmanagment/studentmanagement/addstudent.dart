import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddStudentController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController studentFirstNameController =
      TextEditingController();
  final TextEditingController studentLastNameController =
      TextEditingController();
  final TextEditingController studentAgeController = TextEditingController();
  final TextEditingController studentStageController = TextEditingController();

  final TextEditingController studentEmailController = TextEditingController();
  final TextEditingController studentPasswordController =
      TextEditingController();
  final TextEditingController studentPhoneNumberController =
      TextEditingController();
  final TextEditingController studentBornController = TextEditingController();
///////////////////
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

  var isLoading = false.obs;

  Future<void> addStudent() async {
    if (isLoading.value) return; 

    isLoading.value = true;
    print('Starting addStudent process'); 

    try {
      print('Inserting guardian data'); 
      final guardianResponse = await supabase
          .from('gaurdian')
          .insert({
            'gaurdian_fullname': guardianFullNameController.text,
            'gaurdian_phonenumber': guardianPhoneNumberController.text,
            'gaurdian_born': guardianBornController.text,
            'gaurdian_country': guardianCountryController.text,
            'gaurdian_city': guardianCityController.text,
            'gaurdian_neighberhood': guardianNeighborhoodController.text,
            'gaurdian_streetname': guardianStreetNameController.text,
            'gaurdian_buildnumber': guardianBuildNumberController.text,
          })
          .select('gaurdian_id')
          .single();

      final guardianId = guardianResponse['gaurdian_id'];
      print(
          'Guardian inserted successfully , ID: $guardianId'); 

      print('Inserting student data'); 
      await supabase.from('student').insert({
        'student_firstname': studentFirstNameController.text,
        'student_lastname': studentLastNameController.text,
        'student_age': int.parse(studentAgeController.text),
        'student_stage': studentStageController.text,
        'student_schoolid': myServices.sharedPreferences.getString("schoolid"),
        'student_email': studentEmailController.text,
        'student_password': studentPasswordController.text,
        'student_phonenumber': studentPhoneNumberController.text,
        'student_born': studentBornController.text,
        'student_gaurdianid': guardianId, 
      });

      print('Student inserted successfully'); 
      Get.snackbar('نجاح', 'تمت إضافة الطالب وولي الأمر بنجاح');
      clearForm(); 
    } catch (e) {
      print('Error in addStudent: $e'); 
      Get.snackbar('خطأ', 'فشل في إضافة الطالب: ${e.toString()}');
    } finally {
      isLoading.value = false;
      print('addStudent process completed');
    }
  }

  void clearForm() {
    studentFirstNameController.clear();
    studentLastNameController.clear();
    studentAgeController.clear();
    studentStageController.clear();
    studentEmailController.clear();
    studentPasswordController.clear();
    studentPhoneNumberController.clear();
    studentBornController.clear();

    guardianFullNameController.clear();
    guardianPhoneNumberController.clear();
    guardianBornController.clear();
    guardianCountryController.clear();
    guardianCityController.clear();
    guardianNeighborhoodController.clear();
    guardianStreetNameController.clear();
    guardianBuildNumberController.clear();
  }

  @override
  void onClose() {
    studentFirstNameController.dispose();
    studentLastNameController.dispose();
    studentAgeController.dispose();
    studentStageController.dispose();
    studentEmailController.dispose();
    studentPasswordController.dispose();
    studentPhoneNumberController.dispose();
    studentBornController.dispose();

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
