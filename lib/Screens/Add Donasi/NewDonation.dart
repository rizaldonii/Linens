import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linens/Screens/Add%20Donasi/NewDonationDetails.dart';
import 'package:linens/Screens/Add%20Donasi/ReviewCreateDonation.dart';
import 'package:linens/features/user_auth/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linens/repository/user_repository.dart';
import 'package:linens/models/user_model.dart';

class NewDonationScreen extends StatefulWidget {
  @override
  _NewDonationScreenState createState() => _NewDonationScreenState();
}

class _NewDonationScreenState extends State<NewDonationScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _akunSosmedController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _sekolahController = TextEditingController();
  final TextEditingController _rekeningController = TextEditingController();
  UserRepository userRepository = UserRepository();

  // Controllers for CreateDonationDetails
  final TextEditingController _biayaController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _ceritaController = TextEditingController();
  final TextEditingController _ajakanController = TextEditingController();

  // State variables to store user selections
  final ValueNotifier<int?> _selectedDuration = ValueNotifier<int?>(null);
  final ValueNotifier<String?> _selectedCategory = ValueNotifier<String?>(null);
  final ValueNotifier<XFile?> _selectedImage = ValueNotifier<XFile?>(null);
  final ValueNotifier<String?> _selectedProvince = ValueNotifier<String?>(null);

  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;
      UserModel? userModel = await userRepository.getUserDetails(email);
      _noHpController.text = userModel?.phoneNumber ?? '';
      _akunSosmedController.text = userModel?.instagram ?? '';
    }
  }

  @override
  void dispose() {
    _noHpController.dispose();
    _akunSosmedController.dispose();
    _namaController.dispose();
    _pekerjaanController.dispose();
    _sekolahController.dispose();
    _rekeningController.dispose();
    _pageController.dispose();
    _selectedDuration.dispose();
    _selectedCategory.dispose();
    _selectedImage.dispose();
    // _selectedProvince.dispose();
    super.dispose();
  }

  void _navigateToCreateDonationDetails(BuildContext context) {
    if (isOnFirstPage) {
      _validateFirstPageFields();
      if (!_isValidated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap isi semua form sebelum melanjutkan.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (isOnSecondPage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewCreateDonation(
            nama: _namaController.text,
            noHp: _noHpController.text,
            pekerjaan: _pekerjaanController.text,
            sekolah: _sekolahController.text,
            akunSosmed: _akunSosmedController.text,
            rekening: _rekeningController.text,
            biaya: _biayaController.text,
            judul: _judulController.text,
            cerita: _ceritaController.text,
            ajakan: _ajakanController.text,
            duration: _selectedDuration.value,
            category: _selectedCategory.value,
            image: _selectedImage.value,
            province: _selectedProvince.value,
          ),
        ),
      );
    }
  }

  void _navigateToPreviousPage(BuildContext context) {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _validateFirstPageFields() {
    if (_namaController.text.isNotEmpty &&
        _noHpController.text.isNotEmpty &&
        _pekerjaanController.text.isNotEmpty &&
        _sekolahController.text.isNotEmpty &&
        _akunSosmedController.text.isNotEmpty &&
        _rekeningController.text.isNotEmpty) {
      _isValidated = true;
    } else {
      _isValidated = false;
    }
  }

  bool get isOnFirstPage =>
      _pageController.hasClients && _pageController.page == 0.0;

  bool get isOnSecondPage =>
      _pageController.hasClients && _pageController.page == 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 60, 150, 199),
        title: const Text(
          "BantuBangkit",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildFirstPage(),
                CreateDonationDetails(
                  biayaController: _biayaController,
                  judulController: _judulController,
                  ceritaController: _ceritaController,
                  ajakanController: _ajakanController,
                  selectedDuration: _selectedDuration,
                  selectedCategory: _selectedCategory,
                  selectedImage: _selectedImage,
                  selectedProvince: _selectedProvince,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isOnSecondPage) {
                        _navigateToPreviousPage(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isOnSecondPage ? Colors.white : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(0, 50),
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return isOnSecondPage ? Colors.black87 : Colors.grey;
                      }),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: isOnSecondPage ? Colors.black87 : Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Sebelumnya',
                          style: TextStyle(
                            color:
                                isOnSecondPage ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToCreateDonationDetails(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(0, 50),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selanjutnya',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text("Semoga Sejahtera, Orang Baik!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Image(
                      image: AssetImage("images/id.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text("isi data diri kamu terlebih dahulu ya!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Nama sesuai KTP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Nama sesuai KTP',
              controller: _namaController,
            ),
            SizedBox(height: 20),
            Text(
              'No. HP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'No. HP',
              controller: _noHpController,
            ),
            SizedBox(height: 20),
            Text(
              'Pekerjaan Saat Ini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Pekerjaan Saat Ini',
              controller: _pekerjaanController,
            ),
            SizedBox(height: 20),
            Text(
              'Nama Sekolah/Tempat Kerja',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Nama Sekolah/Tempat Kerja',
              controller: _sekolahController,
            ),
            SizedBox(height: 20),
            Text(
              'Akun Sosmed (Instagram)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Akun Sosmed (Instagram)',
              controller: _akunSosmedController,
            ),
            SizedBox(height: 20),
            Text(
              'Rekening Penerima',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Rekening Penerima',
              controller: _rekeningController,
              hintText: 'Contoh: 46893291032',
            ),
          ],
        ),
      ),
    );
  }
}
