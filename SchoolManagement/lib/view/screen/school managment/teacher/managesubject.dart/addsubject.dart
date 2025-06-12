import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/addsubject.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class AddSubjectScreen extends StatelessWidget {
  final AddSubjectController controller = Get.put(AddSubjectController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مادة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.subjectNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المادة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validInput(value ?? '', 2, 50, null),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value && controller.teachers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.teachers.isEmpty) {
                  return const Text('لا يوجد معلمون متاحون');
                }
                return DropdownButtonFormField<int>(
                  value: controller.selectedTeacherId.value, // Nullable int
                  items: controller.teachers.map((teacher) {
                    return DropdownMenuItem<int>(
                      value: teacher['teacher_id'],
                      child: Text(
                          '${teacher['teacher_firstname']} ${teacher['teacher_lastname']}'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    controller.selectedTeacherId.value =
                        value; 
                  },
                  decoration: const InputDecoration(
                    labelText: 'اختر المعلم',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? 'يرجى اختيار معلم' : null,
                );
              }),
              const SizedBox(height: 20),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.addSubject();
                          }
                        },
                        child: const Text('إضافة المادة'),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
