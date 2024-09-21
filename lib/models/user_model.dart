import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String? instagram;
  final String? phoneNumber;
  final int? totalDonasi;
  final int? saldo;
  final int? jumlahDonasi;
  final String? profileImageUrl;

  const UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.instagram,
    this.phoneNumber,
    this.totalDonasi,
    this.saldo,
    this.jumlahDonasi,
    this.profileImageUrl,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "Password": password,
      "ID": id,
      "Instagram": instagram ?? "",
      "Phone Number": phoneNumber ?? "",
      "Total Donasi": totalDonasi ?? 0,
      'Saldo': saldo ?? 0,
      'Jumlah Donasi': jumlahDonasi ?? 0,
      'Profile Image URL': profileImageUrl ?? ""
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      fullName: data["FullName"],
      email: data["Email"],
      password: data["Password"],
      instagram: data["Instagram"],
      phoneNumber: data["Phone Number"],
      totalDonasi: data["Total Donasi"],
      saldo: data["Saldo"],
      jumlahDonasi: data["Jumlah Donasi"],
      profileImageUrl: data["Profile Image URL"],
    );
  }
}
