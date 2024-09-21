import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linens/Screens/ProfileScreen.dart';
import 'package:linens/features/global/toast.dart';
import 'package:linens/features/user_auth/form_container_widget.dart';
import 'package:linens/models/user_model.dart';
import 'package:linens/repository/user_repository.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserRepository userRepository = UserRepository();
  final ImagePicker _picker = ImagePicker();

  late Future<UserModel?> userFuture;
  File? _image;
  String? _imageUrl;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _akunInstagramController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    userFuture = getUserData();
  }

  Future<UserModel?> getUserData() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    return await userRepository.getUserDetails(email!);
  }

  Future<void> saveProfile() async {
    if (FirebaseAuth.instance.currentUser != null) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String email = currentUser!.email!;
      String fullName = _fullNameController.text;
      String phoneNumber = _noHpController.text;
      String instagram = _akunInstagramController.text;

      try {
        showDialog(
          context: context,
          builder: (context) => Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        String? downloadUrl;
        if (_image != null) {
          downloadUrl = await uploadImageToFirebase(_image!);
        }

        UserModel currentUserModel = await userRepository.getUserDetails(email);

        UserModel updatedUser = UserModel(
          id: currentUserModel.id,
          fullName: fullName,
          email: email,
          password: currentUserModel.password,
          phoneNumber: phoneNumber,
          instagram: instagram,
          totalDonasi: currentUserModel.totalDonasi,
          saldo: currentUserModel.saldo,
          jumlahDonasi: currentUserModel.jumlahDonasi,
          profileImageUrl: downloadUrl ?? currentUserModel.profileImageUrl,
        );

        await userRepository.updateUserRecord(updatedUser);

        showToast(message: "Profil berhasil diperbarui");

        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } catch (e) {
        showToast(message: "Ada kesalahan saat memperbarui profil");
        print("ERROR - $e");
      } finally {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      String fileName = '${FirebaseAuth.instance.currentUser!.uid}.jpg';
      Reference ref =
          FirebaseStorage.instance.ref().child('profileImages').child(fileName);
      UploadTask uploadTask = ref.putFile(image);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _noHpController.dispose();
    _akunInstagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 60, 150, 199),
        title: const Text(
          "Edit Profil",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade200.withOpacity(0.75),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: GestureDetector(
                  onTap: saveProfile,
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              UserModel userData = snapshot.data!;
              _fullNameController.text = userData.fullName;
              _noHpController.text = userData.phoneNumber ?? '';
              _akunInstagramController.text = userData.instagram ?? '';
              _imageUrl = userData.profileImageUrl;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Wrap(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text('Pilih dari Galeri'),
                                    onTap: () {
                                      pickImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_camera),
                                    title: Text('Ambil dari Kamera'),
                                    onTap: () {
                                      pickImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : (_imageUrl != null && _imageUrl!.isNotEmpty
                                        ? NetworkImage(_imageUrl!)
                                        : AssetImage(
                                            "images/default-image.jpg"))
                                    as ImageProvider,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Nama",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FormContainerWidget(
                        controller: _fullNameController,
                        hintText: "Nama Lengkap",
                        isPasswordField: false,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "No HP",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FormContainerWidget(
                        controller: _noHpController,
                        hintText: "No HP",
                        isPasswordField: false,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Akun Instagram",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FormContainerWidget(
                        controller: _akunInstagramController,
                        hintText: "Akun Instagram",
                        isPasswordField: false,
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: const Text("User tidak ditemukan"));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
