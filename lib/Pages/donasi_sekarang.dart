import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linens/features/user_auth/form_container_widget.dart';
import 'package:linens/models/user_model.dart';
import 'package:linens/repository/user_repository.dart';

class PaymentDonasi extends StatefulWidget {
  static const routeName = '/donasi-sekarang';

  @override
  _PaymentDonasiState createState() => _PaymentDonasiState();
}

class _PaymentDonasiState extends State<PaymentDonasi> {
  final numberFormat = NumberFormat('#,##0', 'id');

  late UserModel _userModel;
  late String idCampaign;
  bool isSaldoSelected = false;
  late int userSaldo;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _biayaController = TextEditingController();
  final TextEditingController _pesanSupportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaController.text = '';
    _noHpController.text = '';
    _biayaController.text = '';
    _pesanSupportController.text = '';
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;
      UserRepository userRepository = UserRepository();
      UserModel? userModel = await userRepository.getUserDetails(email);
      setState(() {
        _userModel = userModel!;
        _namaController.text = _userModel.fullName ?? '';
        _noHpController.text = _userModel.phoneNumber ?? '';
        userSaldo = _userModel.saldo ?? 0;
      });
    }
  }

  Future<void> _donasi() async {
    int biayaDonasi = int.tryParse(
            _biayaController.text.replaceAll('Rp ', '').replaceAll('.', '')) ??
        0;

    if (biayaDonasi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Masukkan jumlah donasi yang valid'),
        ),
      );
      return;
    }

    if (biayaDonasi > userSaldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Saldo Anda tidak mencukupi untuk melakukan donasi ini'),
        ),
      );
      return;
    }

    // Update saldo pengguna
    int sisaSaldo = userSaldo - biayaDonasi;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_userModel.id)
        .update({
      'Saldo': sisaSaldo,
      'Jumlah Donasi': (_userModel.jumlahDonasi ?? 0) + 1,
      'Total Donasi': (_userModel.totalDonasi ?? 0) + biayaDonasi,
    });

    // Simpan data donasi
    await FirebaseFirestore.instance.collection('donations').add({
      'campaign_id': idCampaign,
      'user_id': _userModel.id,
      'nama': _namaController.text,
      'nomor_handphone': _noHpController.text,
      'pesan_support': _pesanSupportController.text,
      'jumlah_donasi': biayaDonasi,
      'timestamp': Timestamp.now(),
    });

    // Update campaign
    await FirebaseFirestore.instance
        .collection('campaign')
        .doc(idCampaign)
        .update({
      'dana_sedang_terkumpul': FieldValue.increment(biayaDonasi),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Donasi Berhasil'),
      ),
    );

// Clear form fields after successful donation
    _biayaController.clear();
    _pesanSupportController.clear();

// Navigate back to home navigation
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is String) {
      idCampaign = arguments;
    } else {
      return Scaffold(
        body: Center(
          child: Text('Error: Campaign ID not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 60, 150, 199),
        title: const Text(
          "Donasi",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('campaign')
            .doc(idCampaign)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String judul = data['judul'] ?? '';
          int targetBiaya = data['target_biaya_donasi'] ?? 0;
          int danaTerkumpul = data['dana_sedang_terkumpul'] ?? 0;
          String image = data['foto_url'] ?? '';

          double progressValue = danaTerkumpul / targetBiaya;

          return Padding(
            padding: EdgeInsets.all(8),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Anda akan Berdonasi Pada:"),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: Container(
                              width: 150,
                              height: 150,
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    judul,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dana Terkumpul",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Rp ${numberFormat.format(danaTerkumpul)}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    FormContainerWidget(
                      controller: _biayaController,
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
                            String newText = 'Rp ' +
                                formatter.format(value).replaceAll(",", ".");
                            return newValue.copyWith(
                              text: newText,
                              selection: TextSelection.collapsed(
                                  offset: newText.length),
                            );
                          }
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    FormContainerWidget(
                      labelText: 'Nama',
                      hintText: "Nama Lengkap",
                      keyboardType: TextInputType.text,
                      controller: _namaController,
                    ),
                    SizedBox(height: 10),
                    FormContainerWidget(
                      labelText: 'Nomor Handphone',
                      hintText: "Nomor Handphone",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      controller: _noHpController,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: FormContainerWidget(
                        labelText: 'Pesan dan Support',
                        hintText: "Pesan dan Support",
                        keyboardType: TextInputType.multiline,
                        controller: _pesanSupportController,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Metode Pembayaran:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.account_balance_wallet,
                          color: isSaldoSelected ? Colors.blue : null),
                      title: Text('Saldo'),
                      onTap: () {
                        setState(() {
                          isSaldoSelected = true;
                        });
                      },
                    ),
                    Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _donasi();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(226, 2, 67, 180),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.blue),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Donasi Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
