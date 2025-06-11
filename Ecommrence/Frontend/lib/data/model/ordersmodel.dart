class OrdersModel {
  int? itemsprice;
  int? countitems;
  int? cartId;
  int? cartItemsid;
  int? cartUserid;
  int? cartOrders;
  int? itemsId;
  String? itemsName;
  String? itemsNameAr;
  String? itemsDesc;
  String? itemsDescAr;
  String? itemsImage;
  int? itemsCount;
  int? itemsActive;
  int? itemsPrice;
  int? itemsDiscount;
  String? itemsDate;
  int? itemsCat;
  int? ordersId;
  int? ordersUserid;
  int? ordersAddress;
  int? ordersType;
  int? ordersPricedelivery;
  int? ordersPrice;
  int? ordersCoupon;
  String? ordersTime;
  int? ordersPaymentmethod;
  double? ordersFullprice;
  int? ordersStatus;
  int? addressId;
  int? addressUserid;
  String? addressCity;
  String? addressStreet;
  double? addressLong;
  double? addressLat;
  String? addressName;

  OrdersModel(
      {this.itemsprice,
      this.countitems,
      this.cartId,
      this.cartItemsid,
      this.cartUserid,
      this.cartOrders,
      this.itemsId,
      this.itemsName,
      this.itemsNameAr,
      this.itemsDesc,
      this.itemsDescAr,
      this.itemsImage,
      this.itemsCount,
      this.itemsActive,
      this.itemsPrice,
      this.itemsDiscount,
      this.itemsDate,
      this.itemsCat,
      this.ordersId,
      this.ordersUserid,
      this.ordersAddress,
      this.ordersType,
      this.ordersPricedelivery,
      this.ordersPrice,
      this.ordersCoupon,
      this.ordersTime,
      this.ordersPaymentmethod,
      this.ordersFullprice,
      this.ordersStatus,
      this.addressId,
      this.addressUserid,
      this.addressCity,
      this.addressStreet,
      this.addressLong,
      this.addressLat,
      this.addressName});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    itemsprice = json['itemsprice'];
    countitems = json['countitems'];
    cartId = json['cart_id'];
    cartItemsid = json['cart_itemsid'];
    cartUserid = json['cart_userid'];
    cartOrders = json['cart_orders'];
    itemsId = json['items_id'];
    itemsName = json['items_name'];
    itemsNameAr = json['items_name_ar'];
    itemsDesc = json['items_desc'];
    itemsDescAr = json['items_desc_ar'];
    itemsImage = json['items_image'];
    itemsCount = json['items_count'];
    itemsActive = json['items_active'];
    itemsPrice = json['items_price'];
    itemsDiscount = json['items_discount'];
    itemsDate = json['items_date'];
    itemsCat = json['items_cat'];
    ordersId = json['orders_id'];
    ordersUserid = json['orders_userid'];
    ordersAddress = json['orders_address'];
    ordersType = json['orders_type'];
    ordersPricedelivery = json['orders_pricedelivery'];
    ordersPrice = json['orders_price'];
    ordersCoupon = json['orders_coupon'];
    ordersTime = json['orders_time'];
    ordersPaymentmethod = json['orders_paymentmethod'];
    ordersFullprice = (json['orders_fullprice'] as num?)?.toDouble();
    ordersStatus = json['orders_status'];
    addressId = json['address_id'];
    addressUserid = json['address_userid'];
    addressCity = json['address_city'];
    addressStreet = json['address_street'];
    addressLong = (json['address_long'] as num?)?.toDouble();
    addressLat = (json['address_lat'] as num?)?.toDouble();
    addressName = json['address_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemsprice'] = this.itemsprice;
    data['countitems'] = this.countitems;
    data['cart_id'] = this.cartId;
    data['cart_itemsid'] = this.cartItemsid;
    data['cart_userid'] = this.cartUserid;
    data['cart_orders'] = this.cartOrders;
    data['items_id'] = this.itemsId;
    data['items_name'] = this.itemsName;
    data['items_name_ar'] = this.itemsNameAr;
    data['items_desc'] = this.itemsDesc;
    data['items_desc_ar'] = this.itemsDescAr;
    data['items_image'] = this.itemsImage;
    data['items_count'] = this.itemsCount;
    data['items_active'] = this.itemsActive;
    data['items_price'] = this.itemsPrice;
    data['items_discount'] = this.itemsDiscount;
    data['items_date'] = this.itemsDate;
    data['items_cat'] = this.itemsCat;
    data['orders_id'] = this.ordersId;
    data['orders_userid'] = this.ordersUserid;
    data['orders_address'] = this.ordersAddress;
    data['orders_type'] = this.ordersType;
    data['orders_pricedelivery'] = this.ordersPricedelivery;
    data['orders_price'] = this.ordersPrice;
    data['orders_coupon'] = this.ordersCoupon;
    data['orders_time'] = this.ordersTime;
    data['orders_paymentmethod'] = this.ordersPaymentmethod;
    data['orders_fullprice'] = this.ordersFullprice;
    data['orders_status'] = this.ordersStatus;
    data['address_id'] = this.addressId;
    data['address_userid'] = this.addressUserid;
    data['address_city'] = this.addressCity;
    data['address_street'] = this.addressStreet;
    data['address_long'] = this.addressLong;
    data['address_lat'] = this.addressLat;
    data['address_name'] = this.addressName;
    return data;
  }
}
