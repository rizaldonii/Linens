import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linens/features/user_auth/form_container_widget.dart';

class CreateDonationDetails extends StatefulWidget {
  final TextEditingController biayaController;
  final TextEditingController judulController;
  final TextEditingController ceritaController;
  final TextEditingController ajakanController;
  final ValueNotifier<int?> selectedDuration;
  final ValueNotifier<String?> selectedCategory;
  final ValueNotifier<XFile?> selectedImage;
  final ValueNotifier<String?> selectedProvince;

  CreateDonationDetails({
    required this.biayaController,
    required this.judulController,
    required this.ceritaController,
    required this.ajakanController,
    required this.selectedDuration,
    required this.selectedCategory,
    required this.selectedImage,
    required this.selectedProvince,
  });

  @override
  _CreateDonationDetailsState createState() => _CreateDonationDetailsState();
}

class _CreateDonationDetailsState extends State<CreateDonationDetails> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Calculate duration automatically
        DateTime now = DateTime.now();
        int duration = picked.difference(now).inDays;
        widget.selectedDuration.value = duration + 1;
      });
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    widget.selectedImage.value = image;
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    widget.selectedImage.value = image;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDurationButton(String text, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvinceButton(String text, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
        widget.selectedProvince.value = text; // Set selected province
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(color: Colors.black45, fontSize: 12),
          labelStyle: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Supaya orang lain tau kampanye mu,",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 250,
                    height: 200,
                    child: Image(
                      image: AssetImage("images/yuk-donasi.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Text(
                    "Yuk Berikan Kami Informasi Kampanyemu!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Berapa Biaya yang Dibutuhkan?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Biaya yang Dibutuhkan',
              controller: widget.biayaController,
              hintText: "Rp",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) {
                    return newValue.copyWith(text: 'Rp ');
                  } else {
                    int? value =
                        int.tryParse(newValue.text.replaceAll('.', ''));
                    final formatter = NumberFormat.decimalPattern("id");
                    String newText = 'Rp ' + formatter.format(value);
                    return newValue.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                }),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Berapa lama Galang Dana berlangsung?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 4,
              children: [
                ValueListenableBuilder<int?>(
                  valueListenable: widget.selectedDuration,
                  builder: (context, selectedDuration, child) {
                    return _buildDurationButton(
                      "30 hari",
                      selectedDuration == 30,
                      () {
                        widget.selectedDuration.value = 30;
                        _selectedDate = null; // Reset selected date
                      },
                    );
                  },
                ),
                ValueListenableBuilder<int?>(
                  valueListenable: widget.selectedDuration,
                  builder: (context, selectedDuration, child) {
                    return _buildDurationButton(
                      "60 hari",
                      selectedDuration == 60,
                      () {
                        widget.selectedDuration.value = 60;
                        _selectedDate = null; // Reset selected date
                      },
                    );
                  },
                ),
                ValueListenableBuilder<int?>(
                  valueListenable: widget.selectedDuration,
                  builder: (context, selectedDuration, child) {
                    return _buildDurationButton(
                      "90 hari",
                      selectedDuration == 90,
                      () {
                        widget.selectedDuration.value = 90;
                        _selectedDate = null; // Reset selected date
                      },
                    );
                  },
                ),
                ValueListenableBuilder<int?>(
                  valueListenable: widget.selectedDuration,
                  builder: (context, selectedDuration, child) {
                    return _buildDurationButton(
                      _selectedDate != null
                          ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                          : "Pilih Tanggal",
                      _selectedDate != null,
                      () async {
                        await _selectDate(context);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Beri Judul untuk Kampanye ini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Judul Galang Dana',
              hintText: "Contoh: Sedekah untuk 50 anak jalanan",
              controller: widget.judulController,
            ),
            SizedBox(height: 20),
            Text(
              'Tentukan Kategori untuk Kampanye ini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ValueListenableBuilder<String?>(
                valueListenable: widget.selectedCategory,
                builder: (context, selectedCategory, child) {
                  return Row(
                    children: [
                      _buildCategoryButton(
                        "Kesehatan",
                        selectedCategory == "Kesehatan",
                        () {
                          widget.selectedCategory.value = "Kesehatan";
                        },
                      ),
                      _buildCategoryButton(
                        "Bencana",
                        selectedCategory == "Bencana",
                        () {
                          widget.selectedCategory.value = "Bencana";
                        },
                      ),
                      _buildCategoryButton(
                        "Pendidikan",
                        selectedCategory == "Pendidikan",
                        () {
                          widget.selectedCategory.value = "Pendidikan";
                        },
                      ),
                      _buildCategoryButton(
                        "Tempat Ibadah",
                        selectedCategory == "Tempat Ibadah",
                        () {
                          widget.selectedCategory.value = "Tempat Ibadah";
                        },
                      ),
                      _buildCategoryButton(
                        "Hewan",
                        selectedCategory == "Hewan",
                        () {
                          widget.selectedCategory.value = "Hewan";
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Provinsi Galang Dana dilaksanakan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ValueListenableBuilder<String?>(
                valueListenable: widget.selectedProvince,
                builder: (context, selectedProv, child) {
                  return Row(
                    children: [
                      _buildProvinceButton(
                        "Jawa Timur",
                        selectedProv == "Jawa Timur",
                        () {
                          widget.selectedProvince.value = "Jawa Timur";
                        },
                      ),
                      _buildProvinceButton(
                        "Jawa Barat",
                        selectedProv == "Jawa Barat",
                        () {
                          widget.selectedProvince.value = "Jawa Barat";
                        },
                      ),
                      _buildProvinceButton(
                        "Bali",
                        selectedProv == "Bali",
                        () {
                          widget.selectedProvince.value = "Bali";
                        },
                      ),
                      _buildProvinceButton(
                        "Jawa Tengah",
                        selectedProv == "Jawa Tengah",
                        () {
                          widget.selectedProvince.value = "Jawa Tengah";
                        },
                      ),
                      _buildProvinceButton(
                        "Jakarta",
                        selectedProv == "Jakarta",
                        () {
                          widget.selectedProvince.value = "Jakarta";
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Upload Foto Galang Dana',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ValueListenableBuilder<XFile?>(
              valueListenable: widget.selectedImage,
              builder: (context, selectedImage, child) {
                return GestureDetector(
                  onTap: () => _pickImage(context),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 202, 202, 202),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            offset: Offset(1, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          selectedImage == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Upload Foto',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(selectedImage.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Cerita Galang Dana',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 150,
              child: _buildCustomTextField(
                controller: widget.ceritaController,
                keyboardType: TextInputType.multiline,
                hintText: 'Masukkan cerita galang dana...',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tulis ajakan singkat untuk donasi di kampanye ini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            FormContainerWidget(
              labelText: 'Ajakan Galang Dana',
              hintText:
                  "Contoh: Penghasilan saya 20 Ribu per hari, padahal anak saya butuh 20 juta untuk pengobatan",
              controller: widget.ajakanController,
            ),
          ],
        ),
      ),
    );
  }
}
