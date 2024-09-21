import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linens/models/user_model.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  // Metode untuk membuat pengguna baru
  Future<void> createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Metode untuk mendapatkan detail pengguna berdasarkan email
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      throw Exception("User not found");
    }
    return UserModel.fromSnapshot(snapshot.docs.first);
  }

  // Metode untuk mengambil semua pengguna
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db.collection("Users").get();
    return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }

  // Metode untuk mengupdate record pengguna
  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }

  // Metode untuk stream data pengguna berdasarkan email
  Stream<UserModel> streamUserData(String email) {
    return _db
        .collection("Users")
        .where("Email", isEqualTo: email)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).first);
  }
}
