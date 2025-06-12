import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/auth/schoolforgotpassword_controller.dart';

class SchoolForgotPassword extends StatelessWidget {
  final SchoolForgotPasswordController controller =
      Get.put(SchoolForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Step 1: Enter Email
            if (!controller.isCodeSent.value)
              Column(
                children: [
                  Text(
                    'Enter your email to receive a verification code',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: controller.sendVerificationCode,
                            child: const Text('Send Code'),
                          );
                  }),
                ],
              ),

            // Step 2: Enter Code
            if (controller.isCodeSent.value && !controller.isCodeVerified.value)
              Column(
                children: [
                  Text(
                    'Enter the verification code sent to your email',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.codeController,
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: controller.verifyCode,
                            child: const Text('Verify Code'),
                          );
                  }),
                ],
              ),

            // Step 3: Reset Password
            if (controller.isCodeVerified.value)
              Column(
                children: [
                  Text(
                    'Enter your new password',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: controller.resetPassword,
                            child: const Text('Reset Password'),
                          );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
