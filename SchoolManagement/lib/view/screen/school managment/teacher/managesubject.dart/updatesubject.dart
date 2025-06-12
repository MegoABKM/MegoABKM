import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/updatesubject.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class UpdateSubjectScreen extends StatelessWidget {
  final UpdateSubjectController controller = Get.put(UpdateSubjectController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديث مادة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                labelText: 'ابحث عن مادة',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredSubjects.isEmpty) {
                return const Center(child: Text('لا توجد مواد مطابقة'));
              }
              return SizedBox(
                height: 200, 
                child: ListView.builder(
                  itemCount: controller.filteredSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = controller.filteredSubjects[index];
                    return Card(
                      child: ListTile(
                        title: Text(subject['subject_name']),
                        subtitle: Text(
                            'المعلم: ${subject['teachers']['teacher_firstname']} ${subject['teachers']['teacher_lastname']}'),
                        onTap: () => controller.selectSubject(subject),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
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
                    if (controller.teachers.isEmpty) {
                      return const Text('لا يوجد معلمون متاحون');
                    }
                    return DropdownButtonFormField<int>(
                      value: controller.selectedTeacherId.value,
                      items: controller.teachers.map((teacher) {
                        return DropdownMenuItem<int>(
                          value: teacher['teacher_id'],
                          child: Text(
                              '${teacher['teacher_firstname']} ${teacher['teacher_lastname']}'),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        controller.selectedTeacherId.value = value;
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
                                controller.updateSubject();
                              }
                            },
                            child: const Text('تحديث المادة'),
                          ),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
