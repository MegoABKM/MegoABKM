import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:schoolmanagement/core/constant/routes.dart';
import 'package:schoolmanagement/core/middleware/mymiddleware.dart';
import 'package:schoolmanagement/view/screen/auth/loginhome.dart';
import 'package:schoolmanagement/view/screen/auth/loginschool.dart';
import 'package:schoolmanagement/view/screen/auth/loginstudent.dart';
import 'package:schoolmanagement/view/screen/auth/loginteacher.dart';
import 'package:schoolmanagement/view/screen/auth/schoolforgotpassword.dart';
import 'package:schoolmanagement/view/screen/auth/signupschool.dart';
import 'package:schoolmanagement/view/screen/onboaring.dart';
import 'package:schoolmanagement/view/screen/school%20managment/absent/absentpage.dart';
import 'package:schoolmanagement/view/screen/school%20managment/gaurdian/gaurdiansearch.dart';
import 'package:schoolmanagement/view/screen/school%20managment/schoolclass/createclass.dart';
import 'package:schoolmanagement/view/screen/school%20managment/schoolclass/viewclasses.dart';
import 'package:schoolmanagement/view/screen/school%20managment/settingsschool.dart';
import 'package:schoolmanagement/view/screen/school%20managment/student/addstudent.dart';
import 'package:schoolmanagement/view/screen/school%20managment/student/deletestudent.dart';
import 'package:schoolmanagement/view/screen/school%20managment/student/updatestudent.dart';
import 'package:schoolmanagement/view/screen/school%20managment/student/viewstudent.dart';
import 'package:schoolmanagement/view/screen/school%20managment/studenthomemanagment.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/addsubject.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/addteacher.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/deleteacher.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/managetable/createtimetable.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/managetable/viewtimetables.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/deletesubject.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/updatesubject.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/viewsubject.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/updateteacher.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/viewteacher.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacherhomemanagement.dart';
import 'package:schoolmanagement/view/screen/school%20managment/schoolhome.dart';
import 'package:schoolmanagement/view/screen/student%20managemnt/studentdashboard.dart';
import 'package:schoolmanagement/view/screen/teacher%20managemnt/teacher_dashboard.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => const OnBoarding(), middlewares: [Mymiddleware()]),
  GetPage(name: AppRoute.login, page: () => LoginHome()),
  GetPage(name: AppRoute.loginstudent, page: () => const StudentLogin()),
  GetPage(name: AppRoute.loginschool, page: () => SchoolManagementLogin()),
  GetPage(name: AppRoute.loginteacher, page: () => const TeacherLogin()),
  GetPage(
      name: AppRoute.schoolforgetPassword, page: () => SchoolForgotPassword()),
  GetPage(name: AppRoute.signupschool, page: () => SchoolSignup()),
  GetPage(name: AppRoute.studenthome, page: () => const StudentDashboard()),
  GetPage(
      name: AppRoute.studentdashboard, page: () => const StudentDashboard()),
  GetPage(name: AppRoute.schoolhome, page: () => const SchoolHome()),
  // GetPage(name: AppRoute.homecontainer, page: () => HomeConatiner()),
  GetPage(name: AppRoute.addstudent, page: () => AddStudentScreen()),
  GetPage(name: AppRoute.viewstudent, page: () => ViewStudentsScreen()),
  GetPage(name: AppRoute.updatestudent, page: () => UpdateStudentScreen()),
  GetPage(name: AppRoute.deletestudent, page: () => DeleteStudentScreen()),

  GetPage(name: AppRoute.addteacher, page: () => AddTeacherScreen()),
  GetPage(name: AppRoute.deleteteacher, page: () => DeleteTeacherScreen()),
  GetPage(name: AppRoute.updateteacher, page: () => UpdateTeacherScreen()),
  GetPage(name: AppRoute.viewteachers, page: () => ViewTeachersScreen()),
  GetPage(
      name: AppRoute.teacherhomeschool,
      page: () => const Teacherhomemanagment()),
  GetPage(name: AppRoute.addsubject, page: () => AddSubjectScreen()),
  GetPage(name: AppRoute.viewsubject, page: () => ViewSubjectsScreen()),
  GetPage(name: AppRoute.updatesubject, page: () => UpdateSubjectScreen()),
  GetPage(name: AppRoute.deletesubject, page: () => DeleteSubjectScreen()),
  GetPage(
      name: AppRoute.studentmanagment,
      page: () => const Studenthomemanagment()),

  GetPage(name: AppRoute.onBoarding, page: () => const OnBoarding()),
  GetPage(name: AppRoute.viewtimetable, page: () => const ViewTimetablePage()),
  GetPage(
      name: AppRoute.createtablesubject,
      page: () => const CreateTimetablePage()),
  GetPage(name: AppRoute.createclass, page: () => const CreateClassPage()),
  GetPage(name: AppRoute.viewclasses, page: () => const ViewClassesPage()),

  GetPage(name: AppRoute.absentPage, page: () => const AbsentPage()),
  GetPage(name: AppRoute.gaurdianpage, page: () => const GaurdianSearchPage()),

  GetPage(
      name: AppRoute.settingsschool, page: () => const SchoolSettingsPage()),
  GetPage(name: AppRoute.teacherhome, page: () => const TeacherDashboard()),
  // GetPage(name: "/", page: () => const OnBoarding()),
];
