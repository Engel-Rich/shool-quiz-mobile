// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? age;
  String? loginType;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? points;
  String? photoUrl;
  bool? isAdmin = false;
  bool isTestUser;
  String? referCode;
  String? mobileNumber;
  DateTime? bornDate;
  bool? isOnline;
  String? classe;

  UserModel({
    this.classe,
    this.email,
    this.password,
    this.name,
    this.age,
    this.id,
    this.loginType,
    this.updatedAt,
    this.createdAt,
    this.points = 50,
    this.photoUrl,
    this.isAdmin,
    required this.isTestUser,
    this.bornDate,
    this.isOnline,
    this.referCode,
    this.mobileNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      classe: json['classe'] ?? '',
      isOnline: json.containsKey(UserKeys.isOnline)
          ? json[UserKeys.isOnline] ?? true
          : true,
      email: json[UserKeys.email] ?? '',
      password: json[UserKeys.password] ?? '',
      bornDate: json.containsKey(UserKeys.bornDate)
          ? json[UserKeys.bornDate] ?? null
          : null,
      name: json[UserKeys.name] ?? '',
      age: json[UserKeys.age] ?? '',
      id: json[CommonKeys.id],
      points: json[UserKeys.points] ?? 50,
      loginType: json[UserKeys.loginType],
      photoUrl: json[UserKeys.photoUrl] ?? '',
      isAdmin: json[UserKeys.isAdmin] ?? false,
      mobileNumber: json[UserKeys.mobile] ?? '',
      isTestUser: json[UserKeys.isTestUser] ?? false,
      createdAt: json[CommonKeys.createdAt] != null
          ? (json[CommonKeys.createdAt] as Timestamp).toDate()
          : null,
      updatedAt: json[CommonKeys.updatedAt] != null
          ? (json[CommonKeys.updatedAt] as Timestamp).toDate()
          : null,
      referCode: json[UserKeys.referCode],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserKeys.email] = this.email;
    data['classe'] = this.classe;
    data[UserKeys.bornDate] = this.bornDate;
    data[UserKeys.password] = this.password;
    data[UserKeys.name] = this.name;
    data[UserKeys.age] = this.age;
    data[UserKeys.isOnline] = isOnline ?? true;
    data[CommonKeys.id] = this.id;
    data[UserKeys.points] = this.points;
    data[UserKeys.photoUrl] = this.photoUrl;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[UserKeys.isTestUser] = this.isTestUser;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.referCode] = this.referCode;
    data[UserKeys.mobile] = this.mobileNumber;
    return data;
  }
}
