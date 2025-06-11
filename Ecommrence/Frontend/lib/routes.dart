import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/middleware/mymiddleware.dart';
import 'package:ecommrence/view/screen/address/add.dart';
import 'package:ecommrence/view/screen/address/edit.dart';
import 'package:ecommrence/view/screen/address/view.dart';
import 'package:ecommrence/view/screen/auth/signupcheck/verifycodesignup.dart';
import 'package:ecommrence/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:ecommrence/view/screen/auth/login.dart';
import 'package:ecommrence/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:ecommrence/view/screen/auth/signup.dart';
import 'package:ecommrence/view/screen/auth/forgetpassword/success_passwordreset.dart';
import 'package:ecommrence/view/screen/auth/signupcheck/success_signup.dart';
import 'package:ecommrence/view/screen/auth/forgetpassword/verifycodepassword.dart';
import 'package:ecommrence/view/screen/cart.dart';
import 'package:ecommrence/view/screen/checkout.dart';
import 'package:ecommrence/view/screen/homescreen.dart';
import 'package:ecommrence/view/screen/items.dart';
import 'package:ecommrence/view/screen/language.dart';
import 'package:ecommrence/view/screen/myfavortie.dart';
import 'package:ecommrence/view/screen/onboaring.dart';
import 'package:ecommrence/view/screen/orders/archiveorder.dart';
import 'package:ecommrence/view/screen/orders/ordersdetails.dart';
import 'package:ecommrence/view/screen/orders/pendingorders.dart';
import 'package:ecommrence/view/screen/productdetails.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  // GetPage(name: "/", page: () => const Cart()),

  GetPage(
      name: "/", page: () => const Langauge(), middlewares: [Mymiddleware()]),

  GetPage(name: AppRoute.login, page: () => const Login()),
  GetPage(name: AppRoute.onBoarding, page: () => const OnBoarding()),
  GetPage(name: AppRoute.signUp, page: () => const Signup()),
  GetPage(name: AppRoute.forgetPassword, page: () => const Forgetpassword()),
  GetPage(name: AppRoute.resetPassword, page: () => const ResetPassword()),
  GetPage(name: AppRoute.verifyCode, page: () => const VerifyCode()),
  GetPage(
      name: AppRoute.successReset, page: () => const SuccessResetPassword()),
  GetPage(name: AppRoute.successSignup, page: () => const SuccessSignup()),
  GetPage(
      name: AppRoute.verifyCodeSignup, page: () => const VerifyCodeSignup()),
  GetPage(name: AppRoute.home, page: () => const HomeScreen()),
  GetPage(name: AppRoute.items, page: () => const ItemsPage()),
  GetPage(name: AppRoute.productpage, page: () => const ProductDetails()),
  GetPage(name: AppRoute.myFavorite, page: () => const MyFavortie()),
  GetPage(name: AppRoute.cart, page: () => const Cart()),
  GetPage(name: AppRoute.addressAdd, page: () => const AddMap()),
  GetPage(name: AppRoute.addressView, page: () => const AddressView()),
  GetPage(name: AppRoute.addressUpdate, page: () => const EditAddress()),
  GetPage(name: AppRoute.checkOut, page: () => const CheckOut()),
  GetPage(name: AppRoute.orders, page: () => const PendingOrders()),
  GetPage(name: AppRoute.ordersarchived, page: () => const ArchiveorderView()),
  GetPage(name: AppRoute.ordersdetails, page: () => const OrdersDetails())
];
