import 'package:flutter/material.dart';
import 'package:linens/Screens/AddDonasi.dart';
import 'package:linens/Screens/DonasiSaya.dart';
import 'package:linens/Screens/HomeScreen.dart';
import 'package:linens/Screens/ProfileScreen.dart';

class HomeNavigation extends StatefulWidget {
  static const routeName = '/home-navigation';
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    DonasiSayaScreen(),
    AddDonasiScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.heat_pump_rounded),
            label: "Donasi Saya",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Donasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
