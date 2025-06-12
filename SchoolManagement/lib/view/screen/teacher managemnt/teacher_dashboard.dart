import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/teachermanagment/teacherdashboard_controller.dart';
// Assuming AppThemes.defaultPadding is defined in your project, possibly in a theme helper file.
// If not, you can replace it with a standard EdgeInsets, e.g., const EdgeInsets.all(16.0).
// For example: import 'package:schoolmanagement/core/constant/colortheme.dart'; (if AppThemes is there)

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  // If AppThemes.defaultPadding is not globally accessible, define it here or pass it
  static const EdgeInsets defaultPadding =
      EdgeInsets.all(16.0); // Example fallback

  @override
  Widget build(BuildContext context) {
    Get.put(TeacherDashboardController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, // Uses theme
        iconTheme: theme.appBarTheme.iconTheme, // Ensures drawer icon matches
        title: Text(
          'لوحة تحكم المعلم', // Teacher Dashboard
          style: theme.textTheme.titleLarge, // Uses theme's titleLarge style
        ),
        centerTitle: true,
      ),
      // drawer: const TeacherDrawer(), // Create a TeacherDrawer if needed
      body: GetBuilder<TeacherDashboardController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.teacherId == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'لم يتم العثور على بيانات المعلم. الرجاء المحاولة مرة أخرى أو الاتصال بالدعم.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            );
          }
          return Padding(
            // Replace with your actual AppThemes.defaultPadding if available
            // padding: AppThemes.defaultPadding,
            padding:
                defaultPadding, // Using the fallback or your actual theme padding
            child: ListView(
              children: [
                _buildSectionTitle(context, "الجدول الزمني الخاص بك"),
                if (controller.teacherTimetable.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                        child: Text("لا يوجد جدول زمني لعرضه.",
                            style: theme.textTheme.bodyMedium)),
                  )
                else
                  _buildTimetable(context, controller.teacherTimetable),
                const SizedBox(height: 20),
                _buildSectionTitle(context, "المواد والملفات الخاصة بها"),
                if (controller.teacherSubjects.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                        child: Text(
                      "أنت لا تقوم بتدريس أي مواد حاليًا.",
                      style: theme.textTheme.bodyMedium,
                    )),
                  )
                else
                  _buildSubjectsAndFiles(context, controller),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: Text(
        title,
        // Using headlineMedium as it's defined in your theme for section titles
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTimetable(
      BuildContext context, List<Map<String, dynamic>> timetable) {
    final theme = Theme.of(context);
    Map<String, List<Map<String, dynamic>>> groupedByDay = {};
    for (var entry in timetable) {
      String day = entry['day'] as String? ?? 'غير محدد';
      groupedByDay.putIfAbsent(day, () => []).add(entry);
    }

    List<String> sortedDays = groupedByDay.keys.toList();
    // Ensure controller is found for sorting if _compareDays is not static or passed
    final controller = Get.find<TeacherDashboardController>();
    sortedDays.sort((a, b) => controller.compareDays(a, b));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedDays.map((day) {
        List<Map<String, dynamic>> dayEntries = groupedByDay[day]!;
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day,
                    // Using titleLarge style from theme and overriding color with primaryColor for emphasis
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.primaryColor)),
                const Divider(height: 15, thickness: 1),
                ...dayEntries.map((entry) {
                  final subjectData =
                      entry['subjects'] as Map<String, dynamic>?;
                  final classData = entry['class'] as Map<String, dynamic>?;
                  final timeSlot = entry['time_slot'] as String? ?? 'N/A';
                  final subjectName = subjectData?['subject_name'] as String? ??
                      'مادة غير معروفة';
                  final className =
                      classData?['class_name'] as String? ?? 'فصل غير معروف';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('$subjectName - $className',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.normal)),
                    subtitle: Text('الوقت: $timeSlot',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor)),
                    leading: Icon(Icons.schedule,
                        color: theme.colorScheme
                            .secondary), // Uses theme's secondary color
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectsAndFiles(
      BuildContext context, TeacherDashboardController controller) {
    final theme = Theme.of(context);
    return Column(
      children: controller.teacherSubjects.map((subject) {
        final subjectId = subject['subject_id'];
        final subjectName =
            subject['subject_name'] as String? ?? 'مادة غير معروفة';
        final filesForThisSubject = controller.teacherSubjectFiles
            .where((file) => file['subject_id'] == subjectId)
            .toList();

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            leading: Icon(Icons.book,
                color: theme.primaryColor), // Uses theme's primary color
            title: Text(subjectName,
                style: theme.textTheme.titleMedium), // Uses theme's titleMedium
            iconColor: theme
                .iconTheme.color, // Ensures expansion icon color matches theme
            collapsedIconColor: theme.iconTheme.color,
            children: [
              if (filesForThisSubject.isEmpty)
                ListTile(
                    title: Text("لا توجد ملفات لهذه المادة.",
                        style: theme.textTheme.bodyMedium))
              else
                ...filesForThisSubject.map((file) {
                  final fileName =
                      file['file_name'] as String? ?? 'ملف بدون اسم';
                  final fileType = file['file_type'] as String? ?? '';
                  final filePath = file['file_path'] as String?;
                  return ListTile(
                    leading: Icon(Icons.insert_drive_file,
                        color: theme.colorScheme
                            .secondary), // Uses theme's secondary color
                    title: Text(fileName,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.normal)),
                    subtitle: Text("النوع: $fileType",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor)),
                    trailing: filePath != null
                        ? IconButton(
                            icon:
                                Icon(Icons.download, color: theme.primaryColor),
                            onPressed: () {
                              final url = controller.getDownloadUrl(filePath);
                              print("Attempting to download: $url");
                              // You'd typically use url_launcher here:
                              // import 'package:url_launcher/url_launcher.dart';
                              // if (await canLaunchUrl(Uri.parse(url))) {
                              //   await launchUrl(Uri.parse(url));
                              // } else {
                              //   Get.snackbar("خطأ", "لا يمكن فتح الرابط: $url");
                              // }
                              Get.snackbar(
                                  "تنزيل", "رابط التنزيل (للتجربة): $url");
                            },
                          )
                        : null,
                  );
                }).toList(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor, // Button background
                    foregroundColor: theme
                        .colorScheme.onPrimary, // Text/Icon color on button
                  ),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("رفع ملف لهذه المادة"),
                  onPressed: () {
                    Get.snackbar("تنبيه",
                        "وظيفة رفع الملفات لم تنفذ بعد للمادة: $subjectName");
                  },
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
