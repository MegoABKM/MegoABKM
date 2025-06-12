import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/core/constant/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupschoolController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController schoolEmailController = TextEditingController();
  final TextEditingController schoolPasswordController =
      TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController schoolLearnStageController =
      TextEditingController();
  final TextEditingController schoolLearnTypeController =
      TextEditingController();

  final TextEditingController managerFirstNameController =
      TextEditingController();
  final TextEditingController managerLastNameController =
      TextEditingController();
  final TextEditingController managerEmailController = TextEditingController();
  final TextEditingController managerPhoneNumberController =
      TextEditingController();
  final TextEditingController managerSchoolIdController =
      TextEditingController();

  final TextEditingController locationCountryController =
      TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationNeighborhoodController =
      TextEditingController();
  final TextEditingController locationStreetController =
      TextEditingController();
  final TextEditingController locationBuildingNumberController =
      TextEditingController();

  bool isloading = false;

  final SupabaseClient supabase = Supabase.instance.client;
  Future<void> insertSchoolData() async {
    if (formKey.currentState!.validate()) {
      try {
        isloading = true;
        update();
        final emailExists = await supabase
            .from('school')
            .select('school_email')
            .eq('school_email', schoolEmailController.text)
            .maybeSingle();

        if (emailExists != null) {
          Get.snackbar('Error', 'This email is already registered.');
          return;
        }

        final schoolResponse = await supabase
            .from('school')
            .insert({
              'school_email': schoolEmailController.text,
              'school_password': schoolPasswordController
                  .text, 
              'school_name': schoolNameController.text,
              'school_learnstage': schoolLearnStageController.text,
              'school_learntype': schoolLearnTypeController.text,
            })
            .select('school_id')
            .single(); 

        final schoolId = schoolResponse[
            'school_id']; 

        await supabase.from('locationschool').insert({
          'locationschool_schoolid': schoolId, 
          'locationschool_country': locationCountryController.text,
          'locationschool_city': locationCityController.text,
          'locationschool_state': locationStateController.text,
          'locationschool_neighberhood': locationNeighborhoodController.text,
          'locationschool_street': locationStreetController.text,
          'locationschool_buildnumber': locationBuildingNumberController.text,
        });

        await supabase.from('manager').insert({
          'manager_schoolid': schoolId, 
          'manager_firstname': managerFirstNameController.text,
          'manager_lastname': managerLastNameController.text,
          'manager_email': managerEmailController.text,
          'manager_phonenumber': managerPhoneNumberController.text,
        });
        isloading = false;
        update();
        Get.snackbar('Success', 'School registered successfully');
        Get.offNamed(AppRoute.loginschool);
      } catch (e) {
        Get.snackbar('Error', e.toString());
        print(e);
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields correctly');
    }
  }

  @override
  void onClose() {
    schoolEmailController.dispose();
    schoolPasswordController.dispose();
    schoolNameController.dispose();
    schoolLearnStageController.dispose();
    schoolLearnTypeController.dispose();
    managerFirstNameController.dispose();
    managerLastNameController.dispose();
    managerEmailController.dispose();
    managerPhoneNumberController.dispose();
    managerSchoolIdController.dispose();
    locationCountryController.dispose();
    locationCityController.dispose();
    locationStateController.dispose();
    locationNeighborhoodController.dispose();
    locationStreetController.dispose();
    locationBuildingNumberController.dispose();
    super.onClose();
  }
}
