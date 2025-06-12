import 'package:schoolmanagement/core/constant/imageasset.dart';
import 'package:schoolmanagement/data/model/onboardingmodel.dart';

List<OnBoardingmodel> onBoardingList = [
  OnBoardingmodel(
    title: "مرحبًا بك في مرشد",
    body:
        "نظام متكامل يربط بين المدرسة وأولياء الأمور لمتابعة أداء الطلاب وسلوكهم",
    image: AppImageAsset.onBoardingImageOne,
  ),
  OnBoardingmodel(
    title: "متابعة الحضور والغياب",
    body: "تلقي إشعارات فورية حول حضور وغياب ابنك لضمان متابعته المستمرة",
    image: AppImageAsset.onBoardingImageTwo,
  ),
  OnBoardingmodel(
    title: "إشعارات السلوك والإنذارات",
    body:
        "احصل على تحديثات مباشرة بشأن سلوك الطالب داخل المدرسة وأي إنذارات تصدر",
    image: AppImageAsset.onBoardingImageThree,
  ),
  OnBoardingmodel(
    title: "تواصل مباشر مع المعلمين",
    body: "تفاعل مع معلمي ابنك واطرح استفساراتك لمتابعة تقدمه الأكاديمي",
    image: AppImageAsset.onBoardingImageFour,
  ),
  // OnBoardingmodel(
  //   title: "تجربة مخصصة لك",
  //   body: "اختر بين الوضع الليلي والوضع النهاري لتجربة استخدام مريحة ومناسبة.",
  //   image: AppImageAsset.onBoardingImageFive,
  // ),
];
