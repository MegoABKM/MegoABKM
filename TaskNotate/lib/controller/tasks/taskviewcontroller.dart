import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/base_task_controller.dart';
import 'package:tasknotate/core/functions/alarm.dart';
// import 'package:tasknotate/data/datasource/local/sqldb.dart'; // Inherited
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/view/screen/tasks/update_task.dart';

class Taskviewcontroller extends BaseTaskController {
  // Extend BaseTaskController
  UserTasksModel? task;
  String? index;
  // DateTime? selectedAlarm; // Inherited
  Map<String, dynamic>? decodedsubtask;
  Map<String, String> decodedImages = {};
  List<Map<String, dynamic>> decodedTimeline = [];
  String? categoryName;
  // SqlDb sqlDb = SqlDb(); // Inherited

  // Note: Taskviewcontroller doesn't use titlecontroller, subtaskControllers, etc.
  // from BaseTaskController for editing, so they will be unused but present.

  void decodethemap() {
    if (task?.subtask != null && task?.subtask != "Not Set") {
      decodedsubtask = jsonDecode(task!.subtask!);
    }
  }

  void decodeImages() {
    if (task?.images != null && task?.images != "Not Set") {
      decodedImages = Map<String, String>.from(jsonDecode(task!.images!));
    }
  }

  void decodeTimeline() {
    if (task?.timeline != null && task?.timeline != "Not Set") {
      decodedTimeline =
          List<Map<String, dynamic>>.from(jsonDecode(task!.timeline!));
      decodedTimeline
          .sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
    }
  }

  Future<String?> fromIdToName(String? categoryid) async {
    if (categoryid == null || categoryid.isEmpty || categoryid == "Home")
      return "key_home".tr;
    int? parsedCategoryId = int.tryParse(categoryid);
    if (parsedCategoryId == null)
      return "key_home".tr; // Should not happen if DB stores int
    List<Map<String, dynamic>> response = await sqlDb.readData(
      // sqlDb inherited
      "SELECT categoryName FROM categoriestasks WHERE id = ?",
      [parsedCategoryId],
    );
    return response.isNotEmpty && response[0]['categoryName'] != null
        ? response[0]['categoryName'] as String
        : "key_home".tr;
  }

  Future<void> updateStatus(
      String currentStatus, String id, String targetStatus) async {
    // Renamed parameters for clarity
    int response = await sqlDb.updateData(
      // sqlDb inherited
      "UPDATE tasks SET status = ? WHERE id = ?",
      [targetStatus, id],
    );
    if (response > 0) {
      task = task!.copyWith(status: targetStatus);
      update();
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? dateTime = await selectDateTime(context); // Use helper
    if (dateTime != null) {
      selectedAlarm = dateTime; // selectedAlarm is inherited
      // Ensure task and task.id are not null before proceeding
      if (task != null && task!.id != null && task!.title != null) {
        await setAlarm(selectedAlarm, int.parse(task!.id!), task!.title!);
        await updateReminder(); // This specific updateReminder method
      }
      update();
    }
  }

  Future<void> updateReminder() async {
    String reminderValue = selectedAlarm != null
        ? selectedAlarm!.toIso8601String()
        : "Not Set"; // selectedAlarm inherited
    int response = await sqlDb.updateData(
      // sqlDb inherited
      "UPDATE tasks SET reminder = ? WHERE id = ?",
      [reminderValue, task!.id],
    );
    if (response > 0) task = task!.copyWith(reminder: reminderValue);
    update(); // Update UI if needed
  }

  Future<void> removeReminder() async {
    if (task == null || task!.id == null) {
      Get.snackbar("key_error".tr, "key_no_task_selected".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    await deactivateAlarm({
      'id': task!.id.toString()
    }); // Assuming deactivateAlarm is global or imported
    int response = await sqlDb.updateData(
      // sqlDb inherited
      "UPDATE tasks SET reminder = ? WHERE id = ?",
      ["Not Set", task!.id],
    );
    if (response > 0) {
      task = task!.copyWith(reminder: "Not Set");
      selectedAlarm = null; // selectedAlarm inherited
      update();
    } else {
      Get.snackbar("key_error".tr, "key_failed_to_remove_reminder".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> refreshTask(String taskId) async {
    List<Map<String, dynamic>> response = await sqlDb.readData(
      // sqlDb inherited
      "SELECT * FROM tasks WHERE id = ?",
      [taskId],
    );
    if (response.isNotEmpty) {
      task = UserTasksModel.fromJson(response.first);
      decodethemap();
      decodeImages();
      decodeTimeline();
      categoryName = await fromIdToName(task?.category);
      if (task?.reminder != null && task?.reminder != "Not Set") {
        // Re-assign selectedAlarm on refresh
        selectedAlarm = DateTime.parse(task!.reminder!);
      } else {
        selectedAlarm = null;
      }
      update();
    } else {
      Get.snackbar("key_error".tr, "key_task_not_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      Get.back(); // Or handle error appropriately
    }
  }

  void goToUpdateTask() {
    if (task == null) {
      Get.snackbar("key_error".tr, "key_no_task_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.to(
      const UpdateTask(),
      transition: Transition.noTransition,
      arguments: {
        "task": task,
        "taskindex": index,
        "taskdecodedimages": decodedImages,
        // "taskdecodedtimeline": decodedTimeline, // TaskUpdateController decodes its own from task.timeline
        "categoryname": categoryName,
      },
    );
  }

  @override
  Future<void> onInit() async {
    super.onInit(); // Call base onInit
    final args = Get.arguments;
    if (args == null || args['task'] == null) {
      Get.snackbar("key_error".tr, "key_no_task_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
      return;
    }
    task = args['task'] as UserTasksModel?;
    index = args['taskindex']?.toString();

    if (task == null) {
      Get.snackbar("key_error".tr, "key_no_task_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
      return;
    }

    if (task?.reminder != null && task?.reminder != "Not Set") {
      selectedAlarm =
          DateTime.parse(task!.reminder!); // selectedAlarm inherited
    }
    decodethemap();
    decodeImages();
    decodeTimeline();
    categoryName = await fromIdToName(task?.category);
    // No titlecontroller or subtaskControllers to initialize here for editing
    update(); // Initial update after loading data
  }

  @override
  void onClose() {
    // No specific controllers like descriptioncontroller or contentcontroller to dispose here
    // titlecontroller (if it were used and non-null) and subtaskControllers are handled by base.
    super.onClose();
  }
}
