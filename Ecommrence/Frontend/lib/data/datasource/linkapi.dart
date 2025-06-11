class AppLink {
  static const String server =
      // "http://10.0.2.2/ecommerce"; // will be changed if there is a real host
      "http://192.168.1.112:8080/ecommerce"; // will be changed if there is a real host
  static const String test = "$server/test.php";
// Image ================================================
  static const String imageStatic = "$server/upload";
  static const String imagesCategories = "$imageStatic/categories";
  static const String imagesitems = "$imageStatic/items";
  //-----------------------auth--------------------------------//
  static const String signup = "$server/auth/signup.php";
  static const String verifycode = "$server/auth/verifycodesign.php";
  static const String login = "$server/auth/login.php";
  static const String resendverifycode = "$server/auth/resendcode.php";
  //-----------------------forgetpassword--------------------------------//
  static const String checkemail = "$server/forgetpassword/checkemail.php";
  static const String verifycoderesetpassword =
      "$server/forgetpassword/verifycoderesetpassword.php";
  static const String resetpassword =
      "$server/forgetpassword/resetpassword.php";
  //========================home==================
  static const String homepage = "$server/home.php";
  //=====================items=================
  static const String items = "$server/items/items.php";
  static const String searchitems = "$server/items/search.php";
  //==================favorite============
  static const String addfavorite = "$server/favorite/add.php";
  static const String removefavorite = "$server/favorite/remove.php";
  static const String viewfavorite = "$server/favorite/view.php";
  static const String deletefavorite = "$server/favorite/delete.php";

  //==================favorite============
  static const String addCartItem = "$server/cart/add.php";
  static const String removeCartItem = "$server/cart/delete.php";
  static const String getCountItem = "$server/cart/getcount.php";
  static const String viewCart = "$server/cart/view.php";

  //==================address============
  static const String addAddress = "$server/address/add.php";
  static const String removeAddress = "$server/address/delete.php";
  static const String updateAddress = "$server/address/edit.php";
  static const String viewAddress = "$server/address/view.php";

  //=============coupon=================

  static const String checkCoupon = "$server/coupon/checkcoupon.php";

  //checkout

  static const String checkout = "$server/orders/checkout.php";
  static const String pendingorder = "$server/orders/pending.php";
  static const String archiveorder = "$server/orders/archive.php";
  static const String orderdetails = "$server/orders/details.php";
  static const String orderdelete = "$server/orders/delete.php";
  static const String orderarchive = "$server/orders/archive.php";

  //Notification
  static const String notification = "$server/notification.php";
}
