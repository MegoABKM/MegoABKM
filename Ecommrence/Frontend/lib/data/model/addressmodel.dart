class AddressModel {
  int? addressId;
  int? addressUserid;
  String? addressCity;
  String? addressStreet;
  double? addressLong;
  double? addressLat;
  String? addressName;

  AddressModel(
      {this.addressId,
      this.addressUserid,
      this.addressCity,
      this.addressStreet,
      this.addressLong,
      this.addressLat,
      this.addressName});

  AddressModel.fromJson(Map<String, dynamic> json) {
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
