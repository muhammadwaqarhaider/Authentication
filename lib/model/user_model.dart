import 'dart:convert';

class UserModel {
  String? Name;
  String? email;
  String? phone;
  String? password;
  String? accountType;
  String? profilePicture;
  String? googleId;
  String? facebookId;

  UserModel({
    this.email,this.phone,this.password,this.Name,
    this.accountType, this.profilePicture,this.googleId,this.facebookId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': Name,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
      'accountType': accountType,
      'googleId': googleId,
      'facebookId': facebookId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      Name: map['Name'] as String,
      email: map['email'] as String,
      phone: map['phone'] == null? null : map['phone'] as String,
      profilePicture: map['profilePicture'] == null? null : map['profilePicture'] as String,
      accountType: map['accountType'] == null? null : map['accountType'] as String,
      googleId: map['googleId'] == null? null : map['googleId'] as String,
      facebookId: map['facebookId'] == null? null : map['facebookId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
