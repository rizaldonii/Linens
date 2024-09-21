import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linens/Widgets/HomeNavigation.dart';
import 'firebase_options.dart';
import 'package:linens/Pages/donasi_detail.dart';
import 'package:linens/Pages/donasi_sekarang.dart';
import 'package:linens/features/app/splash_screen/splash_screen.dart';
import 'package:linens/features/user_auth/LoginScreen.dart';
import 'package:linens/provider/all_donasi.dart';
import 'package:provider/provider.dart';
import 'Screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AllDonasi(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          PaymentDonasi.routeName: (ctx) => PaymentDonasi(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          HomeNavigation.routeName: (ctx) => HomeNavigation(),
          LoginScreen.routeName: (context) => LoginScreen(),
        },
        home: SplashScreen(
          child: LoginScreen(),
        ),
      ),
    );
  }
}
