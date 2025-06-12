// lib/screens/create_class_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/classmanagement/crudclass_controller.dart';

class CreateClassPage extends StatelessWidget {
  const CreateClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.put(ClassController());

    return GetBuilder<ClassController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('إنشاء صف جديد')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller.classNameController,
                  decoration: const InputDecoration(labelText: 'اسم الصف'),
                ),
                TextField(
                  controller: controller.placeController,
                  decoration: const InputDecoration(labelText: 'المكان'),
                ),
                DropdownButton<int>(
                  hint: const Text('اختر المرحلة'),
                  value: controller.selectedStage,
                  items: List.generate(12, (index) => index + 1).map((stage) {
                    return DropdownMenuItem<int>(
                      value: stage,
                      child: Text('المرحلة $stage'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedStage = value;
                    controller.update(); 
                  },
                ),
                const SizedBox(height: 20),
                controller.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: controller.createClass,
                        child: const Text('إنشاء الصف'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
