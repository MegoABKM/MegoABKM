import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';

class CategoryDrawerTask extends StatelessWidget {
  final HomeController controller;
  final bool isTaskDrawer;

  const CategoryDrawerTask({
    super.key,
    required this.controller,
    required this.isTaskDrawer,
  });

  Future<List<String>> _fetchTaskTitles(
      BuildContext context, CategoryModel category) async {
    final SqlDb sqlDb = SqlDb();
    List<Map<String, dynamic>> tasksResponse;
    if (category.id == null) {
      tasksResponse = await sqlDb.readData(
        'SELECT title FROM tasks WHERE categoryId IS NULL',
      );
    } else {
      tasksResponse = await sqlDb.readData(
        'SELECT title FROM tasks WHERE categoryId = ?',
        [category.id],
      );
    }
    return tasksResponse.map((task) => task['title'] as String).toList();
  }

  Future<void> _addCategory(String name) async {
    try {
      await controller.addTaskCategory(name);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_add_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _updateCategory(int? id, String name) async {
    if (id == null) {
      Get.snackbar('key_error'.tr, 'key_cannot_update_home'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await controller.updateTaskCategory(id, name);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_update_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _deleteCategory(int? id, RxBool isDeleting) async {
    if (id == null) {
      Get.snackbar('key_error'.tr, 'key_cannot_delete_home'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await controller.deleteTaskCategory(id);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _setTasksToPending(int? id, String categoryName) async {
    try {
      await controller.setTasksToPending(id);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_set_pending'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final RxBool showAddField = false.obs;
    final RxBool isDeleting = false.obs;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.appTheme.colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'key_categories'.tr,
                  style: TextStyle(
                    color: context.appTheme.colorScheme.onSecondary,
                    fontSize: context.scaleConfig.scaleText(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      showAddField.value ? Icons.close : Icons.add,
                      color: context.appTheme.colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      showAddField.value = !showAddField.value;
                      if (!showAddField.value) {
                        nameController.clear();
                      }
                    },
                    tooltip: showAddField.value
                        ? 'key_cancel'.tr
                        : 'key_add_category'.tr,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => showAddField.value
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleConfig.scale(16),
                      vertical: context.scaleConfig.scale(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'key_category_name'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: context.scaleConfig.scale(12),
                                vertical: context.scaleConfig.scale(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.scaleConfig.scale(8)),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isNotEmpty) {
                              await _addCategory(nameController.text);
                              nameController.clear();
                              showAddField.value = false;
                            } else {
                              Get.snackbar(
                                'key_error'.tr,
                                'key_category_name_empty'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                context.appTheme.colorScheme.secondary,
                            foregroundColor:
                                context.appTheme.colorScheme.onSecondary,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaleConfig.scale(16),
                              vertical: context.scaleConfig.scale(8),
                            ),
                          ),
                          child: Text('key_add'.tr),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: GetBuilder<HomeController>(
              id: 'task-category-view',
              builder: (controller) {
                final List<CategoryModel> categories =
                    List.from(controller.taskCategories);
                if (controller.taskdata.any((task) => task.category == null)) {
                  if (!categories.any((cat) => cat.categoryName == "Home")) {
                    categories.insert(
                        0, CategoryModel(id: null, categoryName: "Home"));
                  }
                }

                if (categories.isEmpty) {
                  return Center(child: Text('key_no_categories'.tr));
                }

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ExpansionTile(
                      leading: Icon(
                        FontAwesomeIcons.folder,
                        color: context.appTheme.colorScheme.primary,
                        size: context.scaleConfig.scale(20),
                      ),
                      title: Text(
                        category.categoryName,
                        style: TextStyle(
                          fontSize: context.scaleConfig.scaleText(16),
                        ),
                      ),
                      onExpansionChanged: (expanded) {
                        if (!expanded) {
                          if (isTaskDrawer &&
                              controller.selectedTaskCategoryId.value ==
                                  category.id) {
                            controller.filterTasksByCategory(null);
                          }
                        }
                      },
                      children: [
                        if (isTaskDrawer)
                          FutureBuilder<List<String>>(
                            future: _fetchTaskTitles(context, category),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('key_error'.tr),
                                );
                              }
                              final taskTitles = snapshot.data ?? [];
                              if (taskTitles.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.scaleConfig.scale(16),
                                  vertical: context.scaleConfig.scale(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'key_tasks'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            context.scaleConfig.scaleText(14),
                                        color: context
                                            .appTheme.colorScheme.primary,
                                      ),
                                    ),
                                    SizedBox(
                                        height: context.scaleConfig.scale(4)),
                                    ...taskTitles.map((title) => Padding(
                                          padding: EdgeInsets.only(
                                            left: context.scaleConfig.scale(8),
                                            bottom:
                                                context.scaleConfig.scale(4),
                                          ),
                                          child: Text(
                                            "- $title",
                                            style: TextStyle(
                                              fontSize: context.scaleConfig
                                                  .scaleText(14),
                                              color: context.appTheme
                                                  .colorScheme.onSurface,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleConfig.scale(16),
                            vertical: context.scaleConfig.scale(8),
                          ),
                          child: Wrap(
                            spacing: context.scaleConfig.scale(8),
                            children: [
                              TextButton.icon(
                                icon: Icon(
                                  Icons.edit,
                                  color: context.appTheme.colorScheme.primary,
                                  size: context.scaleConfig.scale(18),
                                ),
                                label: Text('key_edit'.tr),
                                onPressed: () {
                                  _showEditCategoryDialog(context, category);
                                },
                              ),
                              Obx(
                                () => TextButton.icon(
                                  icon: isDeleting.value
                                      ? SizedBox(
                                          width: context.scaleConfig.scale(18),
                                          height: context.scaleConfig.scale(18),
                                          child: CircularProgressIndicator(
                                            strokeWidth:
                                                context.scaleConfig.scale(2),
                                            color: Colors.redAccent,
                                          ),
                                        )
                                      : Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                          size: context.scaleConfig.scale(18),
                                        ),
                                  label: Text('key_delete'.tr),
                                  onPressed: isDeleting.value
                                      ? null
                                      : () {
                                          _confirmDeleteCategory(
                                              context, category, isDeleting);
                                        },
                                ),
                              ),
                              TextButton.icon(
                                icon: Icon(
                                  Icons.refresh,
                                  color: context.appTheme.colorScheme.primary,
                                  size: context.scaleConfig.scale(18),
                                ),
                                label: Text('key_set_pending'.tr),
                                onPressed: () {
                                  _confirmSetTasksToPending(context, category);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryModel category) {
    print('Opening edit category dialog for ${category.categoryName}');
    final TextEditingController nameController =
        TextEditingController(text: category.categoryName);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_edit_category'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'key_category_name'.tr,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancel button pressed for edit dialog');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              print('Update button pressed for edit dialog');
              if (nameController.text.isNotEmpty) {
                await _updateCategory(category.id, nameController.text);
                print('Closing edit dialog after update');
                Navigator.of(dialogContext).pop();
              } else {
                Get.snackbar(
                  'key_error'.tr,
                  'key_category_name_empty'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: Text('key_update'.tr),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(
      BuildContext context, CategoryModel category, RxBool isDeleting) {
    print('Opening delete category dialog for ${category.categoryName}');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_delete_category'.tr),
        content: Text('key_confirm_delete_category'
            .tr
            .replaceFirst('{}', category.categoryName)),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancel button pressed for delete dialog');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              print('Delete button pressed for delete dialog');
              isDeleting.value = true;
              await _deleteCategory(category.id, isDeleting);
              isDeleting.value = false;
              print('Closing delete dialog after deletion');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_delete'.tr),
          ),
        ],
      ),
    );
  }

  void _confirmSetTasksToPending(BuildContext context, CategoryModel category) {
    print('Opening set tasks pending dialog for ${category.categoryName}');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_set_tasks_pending'.tr),
        content: Text('key_confirm_set_tasks_pending'
            .tr
            .replaceFirst('{}', category.categoryName)),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancel button pressed for set pending dialog');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              print('Confirm button pressed for set pending dialog');
              await _setTasksToPending(category.id, category.categoryName);
              print('Closing set pending dialog after confirmation');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_confirm'.tr),
          ),
        ],
      ),
    );
  }
}
