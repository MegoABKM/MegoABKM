import 'dart:convert';
// import 'dart:io'; // From base
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart'; // From base
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/controller/tasks/taskviewcontroller.dart';
import 'package:tasknotate/core/functions/alarm.dart';
// import 'package:tasknotate/core/functions/saveimage.dart'; // From base
// import 'package:tasknotate/data/datasource/local/sqldb.dart'; // Inherited
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'base_task_controller.dart'; // Import base

class TaskUpdatecontroller extends BaseTaskController {
  // Extend BaseTaskController
  UserTasksModel? task;
  String? index;
  // DateTime? selectedAlarm; // Inherited
  DateTime? selectedDate; // Finish date for update
  DateTime? selectedStartDate; // Start date for update
  Map<String, dynamic>? decodedsubtask;
  TextEditingController? contentcontroller;
  // TextEditingController? titlecontroller; // Inherited
  final List<String> statuses = [
    "Pending",
    "In Progress",
    "Completed"
  ]; // Can be removed if base one is identical and used
  final List<String> priorities = ["Not Set", "Low", "Medium", "High"];
  bool statusprority = false;
  bool statusdateandtime = false;
  bool statusstartDate = false;
  bool statussubtasks = false;
  bool statusreminder = false;
  // bool statustimeline = false; // Inherited
  // var timelineTiles = <Map<String, dynamic>>[].obs; // Inherited
  Map<String, String> decodedImages = {}; // Specific image map for update
  // SqlDb sqlDb = SqlDb(); // Inherited
  // String? newsubtasksconverted; // Inherited
  String? newimagesconverted; // Specific: source map 'decodedImages'
  // List<TextEditingController> subtaskControllers = []; // Inherited
  // Map<int, String> subtasks = {}; // Inherited
  int? selectedCategoryId;
  List<CategoryModel> categories = [];
  HomeController homeController = Get.find<HomeController>();

  String getTranslatedPriority(String priority) {
    switch (priority) {
      case "Not Set":
        return "166".tr;
      case "Low":
        return "160".tr;
      case "Medium":
        return "161".tr;
      case "High":
        return "162".tr;
      default:
        return priority;
    }
  }

  String getTranslatedStatus(String status) {
    switch (status) {
      case "Pending":
        return "163".tr;
      case "In Progress":
        return "164".tr;
      case "Completed":
        return "165".tr;
      default:
        return status;
    }
  }

  void decodeTimeline() {
    if (task?.timeline != null && task!.timeline != "Not Set") {
      super.timelineTiles.value = // Use super for inherited member
          List<Map<String, dynamic>>.from(jsonDecode(task!.timeline!));
      super
          .timelineTiles
          .sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
      super.statustimeline = true; // Use super
    } else {
      super.timelineTiles.value = [];
      super.statustimeline = false;
    }
  }

  void toggleTimeline() {
    // This is specific to TaskUpdateController's logic
    super.statustimeline = !super.statustimeline;
    if (!super.statustimeline) super.timelineTiles.clear();
    update();
  }

  // addTimelineTile(...) is inherited
  // deleteTimelineTile(...) is inherited
  // addtosubtasktextfield() is inherited
  // removeSubtask(int index) is inherited

  void fromMapToString(String type) {
    if (type == "subtasks") {
      convertSubtasksMapToString(); // Use helper from base
    } else {
      // Assuming "images"
      final stringKeyedMap =
          decodedImages.map((key, value) => MapEntry(key.toString(), value));
      newimagesconverted = jsonEncode(stringKeyedMap);
    }
  }

  Future<void> deactivateAlarm() async {
    if (task?.id != null) {
      // Ensure task and id are not null
      await Alarm.stop(int.parse(task!.id!));
    }
  }

  // saveAllSubtasks() is inherited

  Future<void> pickDateTime(BuildContext context, String type) async {
    final DateTime? dateTime = await selectDateTime(context); // Use helper
    if (dateTime != null) {
      switch (type) {
        case "alarm":
          selectedAlarm = dateTime; // selectedAlarm is inherited
          break;
        case "startdate":
          selectedStartDate = dateTime;
          break;
        case "dateandtime": // This corresponds to finish date
          selectedDate = dateTime;
          break;
      }
      update();
    }
  }

  void switchstatusbutton(bool value, String type) {
    switch (type) {
      case "priority":
        statusprority = value;
        if (!value) task = task!.copyWith(priority: "Not Set");
        break;
      case "dateandtime":
        statusdateandtime = value;
        if (!value) selectedDate = null;
        break;
      case "startdate":
        statusstartDate = value;
        if (!value) selectedStartDate = null;
        break;
      case "subtasks":
        statussubtasks = value;
        if (!value) {
          for (var controller in super.subtaskControllers)
            controller.dispose(); // Use super
          super.subtaskControllers.clear(); // Use super
          super.subtasks.clear(); // Use super
        }
        break;
      case "reminder":
        statusreminder = value;
        if (!value) selectedAlarm = null; // selectedAlarm is inherited
        break;
      case "timeline":
        super.statustimeline = value; // Use super
        if (!value) super.timelineTiles.clear(); // Use super
        break;
    }
    update();
  }

  void assigndateifnotset() {
    if (task?.estimatetime != null && task?.estimatetime != "Not Set") {
      selectedDate = DateTime.parse(task!.estimatetime!);
      statusdateandtime = true;
    }
    if (task?.reminder != null && task?.reminder != "Not Set") {
      selectedAlarm =
          DateTime.parse(task!.reminder!); // selectedAlarm inherited
      statusreminder = true;
    }
    if (task?.starttime != null && task?.starttime != "Not Set") {
      selectedStartDate = DateTime.parse(task!.starttime!);
      statusstartDate = true;
    }
    update(); // Potentially not needed if UI updates reactively or called elsewhere
  }

  Future<void> updateReminder() async {
    // This method is specific to update flow
    String reminderValue =
        selectedAlarm != null ? selectedAlarm!.toIso8601String() : "Not Set";
    int response = await sqlDb.updateData(
      // sqlDb inherited
      "UPDATE tasks SET reminder = ? WHERE id = ?",
      [reminderValue, task!.id],
    );
    if (response > 0) task = task!.copyWith(reminder: reminderValue);
    // update(); // Caller might handle update
  }

  Future<void> updatetaskafteredit() async {
    if (statusreminder && selectedAlarm == null) {
      return Get.defaultDialog(/* ... */);
    }
    if (statusdateandtime && selectedDate == null) {
      return Get.defaultDialog(/* ... */);
    }

    saveAllSubtasks(); // Inherited: populates inherited 'subtasks'
    if (super.subtasks.isNotEmpty) {
      // Check inherited 'subtasks'
      fromMapToString("subtasks"); // Sets inherited 'newsubtasksconverted'
    } else {
      newsubtasksconverted = "Not Set"; // inherited
      statussubtasks = false;
    }

    if (decodedImages.isNotEmpty) {
      fromMapToString("images"); // Sets 'newimagesconverted'
    } else {
      newimagesconverted = "Not Set";
    }

    String timelineJson = super.statustimeline && super.timelineTiles.isNotEmpty
        ? jsonEncode(super.timelineTiles) // Use super
        : "Not Set";

    int response = await sqlDb.updateData(
      // sqlDb inherited
      "UPDATE tasks SET title = ?, content = ?, estimatetime = ?, starttime = ?, reminder = ?, status = ?, priority = ?, subtask = ?, images = ?, timeline = ?, categoryId = ? WHERE id = ?",
      [
        titlecontroller!.text, // titlecontroller inherited
        contentcontroller!.text.isNotEmpty ? contentcontroller!.text : "",
        statusdateandtime && selectedDate != null
            ? selectedDate!.toIso8601String()
            : "Not Set",
        statusstartDate && selectedStartDate != null
            ? selectedStartDate!.toIso8601String()
            : "Not Set",
        statusreminder && selectedAlarm != null
            ? selectedAlarm!.toIso8601String()
            : "Not Set", // selectedAlarm inherited
        task?.status,
        statusprority ? task?.priority : "Not Set",
        statussubtasks && super.subtasks.isNotEmpty
            ? newsubtasksconverted
            : "Not Set", // inherited
        decodedImages.isNotEmpty ? newimagesconverted : "Not Set",
        timelineJson,
        selectedCategoryId,
        task?.id,
      ],
    );

    if (response > 0) {
      if (!statusreminder) await deactivateAlarm();
      if (statusreminder && selectedAlarm != null) {
        await setAlarm(selectedAlarm, int.parse(task!.id!), task!.title!);
      }
      await homeController.getTaskData();
      final viewController = Get.find<Taskviewcontroller>();
      await viewController.refreshTask(task!.id!);
      Get.back();
    } else {
      Get.snackbar("key_error".tr, "key_failed_to_update_task".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteImage(String imagePath) async {
    bool deleted = await deleteFileInternal(imagePath); // Use helper from base
    if (deleted) {
      decodedImages.removeWhere((key, value) => value == imagePath);
      update();
      if (decodedImages.isNotEmpty) {
        fromMapToString("images"); // For newimagesconverted
        await sqlDb.updateData(
          // sqlDb inherited
          "UPDATE tasks SET images = ? WHERE id = ?",
          [newimagesconverted, task!.id],
        );
      } else {
        await sqlDb.updateData(
          "UPDATE tasks SET images = ? WHERE id = ?",
          ["Not Set", task!.id],
        );
      }
    }
  }

  // Specific image adding for TaskUpdateController
  void addValue(String value) {
    int counter = decodedImages.length; // Uses decodedImages specific map
    decodedImages[counter.toString()] = value;
    update();
  }

  Future<void> pickImage() async {
    String? savedPath = await pickAndSaveImage(); // Use helper from base
    if (savedPath != null) {
      addValue(savedPath); // Calls this class's addValue
      // Original does not call fromMapToString or DB update here
    }
  }

  Future<void> fetchCategories() async {
    await homeController.getTaskCategories();
    categories = homeController.taskCategories;
    update();
  }

  @override
  void onInit() {
    super.onInit(); // Call base onInit
    task = Get.arguments['task'] as UserTasksModel?;
    index = Get.arguments['taskindex'];
    decodedImages = Get.arguments['taskdecodedimages'] ?? {};
    selectedCategoryId =
        int.tryParse(task?.category ?? ""); // Ensure parsing handles null

    contentcontroller = TextEditingController(text: task?.content);
    titlecontroller =
        TextEditingController(text: task?.title); // titlecontroller inherited

    assigndateifnotset();
    statusprority = task?.priority != null && task?.priority != "Not Set";
    // statusdateandtime, statusreminder, statussubtasks are set in assigndateifnotset or based on task

    if (task?.subtask != null && task?.subtask != "Not Set") {
      statussubtasks = true; // Ensure this is set if there are subtasks
      decodedsubtask = jsonDecode(task!.subtask!);
      decodedsubtask!.forEach((key, value) {
        // int subtaskIndex = int.tryParse(key) ?? -1; // Original key is string '0', '1' etc from map
        // The subtaskControllers list is 0-indexed naturally.
        super
            .subtaskControllers
            .add(TextEditingController(text: value as String)); // Use super
      });
    }
    decodeTimeline();
    fetchCategories();
  }

  @override
  void onClose() {
    contentcontroller?.dispose();
    // titlecontroller and subtaskControllers are disposed by base class
    super.onClose(); // Call base onClose
  }
}
