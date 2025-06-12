import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SchoolForgotPasswordController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isCodeSent = false.obs;
  var isCodeVerified = false.obs;

  // Send verification code to email
  Future<void> sendVerificationCode() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;

    try {
     
      final code = _generateVerificationCode();

   
      await supabase.from('passwordreset').insert({
        'email': emailController.text,
        'code': code,
        'expires_at':
            DateTime.now().add(const Duration(minutes: 10)).toIso8601String(),
      });

     
      await supabase.auth.signInWithOtp(
        email: emailController.text,
        data: {
          'code': code, 
        },
      );

      isCodeSent.value = true;
      Get.snackbar('Success', 'Verification code sent to your email');
    } catch (e) {
      Get.snackbar(
          'Error', 'Failed to send verification code: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> verifyCode() async {
    if (codeController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the verification code');
      return;
    }

    isLoading.value = true;

    try {
   
      final response = await supabase
          .from('password_resets')
          .select()
          .eq('email', emailController.text)
          .eq('code', codeController.text)
          .gte('expires_at', DateTime.now().toIso8601String())
          .single();

      if (response != null) {
        isCodeVerified.value = true;
        Get.snackbar('Success', 'Code verified');
      } else {
        Get.snackbar('Error', 'Invalid or expired code');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify code: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a new password');
      return;
    }

    isLoading.value = true;

    try {
      await supabase
          .from('users') 
          .update({'password': newPasswordController.text}).eq(
              'email', emailController.text);

      await supabase
          .from('password_resets')
          .delete()
          .eq('email', emailController.text);

      Get.snackbar('Success', 'Password reset successfully');
      Get.back(); 
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset password: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String _generateVerificationCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
