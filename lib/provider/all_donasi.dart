import 'package:flutter/material.dart';
import '../models/Donasi.dart';

class AllDonasi with ChangeNotifier {
  List<Campaign> _alldonasi = [];

  List<Campaign> get alldonasi {
    return [..._alldonasi];
  }

  // void addDonasi() {
  //   _alldonasi.add(value);
  //   notifyListeners();
  // }
}
