import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linens/Widgets/HomeNavigation.dart';
import 'package:linens/features/global/toast.dart';
import 'package:linens/features/user_auth/auth_service.dart';
import 'package:linens/features/user_auth/form_container_widget.dart';
import 'package:linens/models/user_model.dart';
import 'package:linens/repository/user_repository.dart';
import './LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final UserRepository _userRepository = UserRepository(); // Create instance

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _retypePasswordController =
      TextEditingController(); // New controller

  bool isSigningUp = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose(); // Dispose new controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "BantuBangkit",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            FormContainerWidget(
              controller: _fullNameController,
              hintText: "Nama Lengkap",
              isPasswordField: false,
            ),
            SizedBox(height: 20),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            SizedBox(height: 20),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(height: 20),
            FormContainerWidget(
              controller: _retypePasswordController, // New field
              hintText: "Re-type Password",
              isPasswordField: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: isSigningUp
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.blue),
                    ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sudah punya akun?"),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String retypePassword = _retypePasswordController.text.trim();

    if (password != retypePassword) {
      setState(() {
        isSigningUp = false;
      });
      showToast(message: "Password tidak cocok. Silakan coba lagi.");
      return;
    }

    try {
      final user = await _auth.signUpWithEmailAndPassword(email,
          password); // Use your existing signUpWithEmailAndPassword function

      if (user != null) {
        // Create UserModel and use `UserRepository` to save to Firestore
        UserModel userModel = UserModel(
          id: user.uid, // Or use 'user.uid' if you prefer saving UID directly
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await _userRepository.createUser(userModel);

        showToast(message: "Akun berhasil dibuat");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeNavigation()),
            (route) => false);
      } else {
        showToast(message: "Terjadi kesalahan.");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isSigningUp = false;
      });
      if (e.code == 'email-already-in-use') {
        showToast(message: 'Alamat email sudah pernah digunakan.');
      } else {
        showToast(message: 'Terjadi kesalahan: ${e.code}');
      }
    }

    setState(() {
      isSigningUp = false;
    });
  }
}
