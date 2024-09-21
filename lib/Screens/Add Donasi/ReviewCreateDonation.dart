import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linens/Widgets/HomeNavigation.dart';

class ReviewCreateDonation extends StatelessWidget {
  final String nama;
  final String noHp;
  final String pekerjaan;
  final String sekolah;
  final String akunSosmed;
  final String rekening;
  final String biaya;
  final String judul;
  final String cerita;
  final String ajakan;
  final int? duration;
  final String? category;
  final XFile? image;
  final String? province;
  final void Function(DateTime)? onEndDateSelected;

  ReviewCreateDonation({
    required this.nama,
    required this.noHp,
    required this.pekerjaan,
    required this.sekolah,
    required this.akunSosmed,
    required this.rekening,
    required this.biaya,
    required this.judul,
    required this.cerita,
    required this.ajakan,
    required this.duration,
    required this.category,
    required this.image,
    required this.province,
    this.onEndDateSelected,
    DateTime? selectedEndDate,
  });

  String _calculateEndDate(int? duration) {
    if (duration == null) return 'N/A';
    final now = DateTime.now();
    final endDate = now.add(Duration(days: duration));
    return DateFormat('dd MMM yyyy').format(endDate);
  }

  @override
  Widget build(BuildContext context) {
    final endDate = _calculateEndDate(duration);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 60, 150, 199),
        title: const Text(
          "Review Kampanye",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text("Sedikit Lagi!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Image(
                      image: AssetImage("images/check.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text("Pastikan data yang kamu berikan sudah benar ya!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ],
              ),
            ),
            Divider(),
            _buildSection(
              context,
              "Data Diri",
              [
                _buildTextItem("Nama Sesuai KTP", nama),
                _buildTextItem("No.Hp", noHp),
                _buildTextItem("Pekerjaan", pekerjaan),
                _buildTextItem("Sekolah/Tempat Kerja", sekolah),
                _buildTextItem("Akun Sosmed", akunSosmed),
                _buildTextItem("Rekening Penerima", rekening),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              "Target Donasi",
              [
                _buildTextItem("Target Biaya Donasi", biaya),
                _buildTextItem("Judul", judul),
                _buildTextItem("Provinsi", province ?? 'N/A'),
                _buildTextItem(
                    "Durasi", duration != null ? '$duration hari' : 'N/A'),
                _buildTextItem("Tanggal Kampanye Berakhir", endDate),
                _buildTextItem("Kategori", category ?? 'N/A'),
                _buildTextItem("Cerita Kampanye", cerita),
                _buildTextItem("Ajakan", ajakan),
                _buildImageItem("Foto Galang Dana", image),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () => _showConfirmationDialog(context),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 255), width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 202, 202, 202),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 7, 8, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.blue,
                    child: Text(
                      title == "Data Diri" ? "1" : "2",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
            ),
            Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildImageItem(String label, XFile? image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        if (image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.file(
                File(image.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Konfirmasi Pengajuan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                "Apakah Anda yakin data yang telah diisi sudah benar dan ingin mengajukan pengajuan?",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () =>
                      _submitCampaign(context), // Call _submitCampaign method
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255), width: 2),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int parseAmount(String amount) {
    // Menghilangkan semua karakter kecuali angka
    String cleanAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');

    // Parsing string yang bersih menjadi integer
    return int.tryParse(cleanAmount) ?? 0;
  }

  void _submitCampaign(BuildContext context) async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate unique campaign ID
      String campaignId = DateTime.now().millisecondsSinceEpoch.toString();

      // Get current user from FirebaseAuth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('User not authenticated');
        return;
      }

      // Calculate endDate
      final endDate = _calculateEndDate(duration);

      // Parse biaya to integer
      int parsedBiaya = parseAmount(biaya);

      // Upload image to Firebase Storage
      String imageUrl = await uploadImageToStorage(image, campaignId);

      // Prepare data to be saved
      Map<String, dynamic> campaignData = {
        'id_campaign': campaignId,
        'id_pembuat': currentUser.uid,
        'nama_sesuai_ktp': nama,
        'pekerjaan': pekerjaan,
        'no.handphone': noHp,
        'akun_sosmed': akunSosmed,
        'sekolah_tempat_kerja': sekolah,
        'rekening_penerima': rekening,
        'judul': judul,
        'target_biaya_donasi': parsedBiaya,
        'dana_sedang_terkumpul': 0,
        'durasi': duration,
        'tanggal_kampanye_berakhir': endDate,
        'kategori': category,
        'cerita_kampanye': cerita,
        'ajakan': ajakan,
        'isVERIFIED': false,
        'foto_url': imageUrl, // Add image URL to campaign data
      };

      // Save data to Firestore in 'campaign' collection
      await firestore.collection('campaign').doc(campaignId).set(campaignData);

      // After successful save, navigate to HomeNavigation without back arrow in AppBar
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeNavigation()),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Campaign submitted successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      // Handle error if failed to save to Firestore or upload image
      print('Error submitting campaign: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengajukan kampanye. Silakan coba lagi.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> uploadImageToStorage(XFile? image, String campaignId) async {
    if (image == null) {
      return ''; // Handle case when no image is selected
    }

    try {
      // Access Firebase storage instance
      final firebaseStorage = FirebaseStorage.instance;

      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref =
          firebaseStorage.ref().child('campaignImages/$campaignId.jpg');

      // Upload file to Firebase Storage
      await ref.putFile(File(image.path));

      // Get download URL
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw Exception('Failed to upload image');
    }
  }
}
