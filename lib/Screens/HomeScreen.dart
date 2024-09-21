import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linens/Screens/HomeScreen%20Category/Category.dart';
import 'package:linens/Widgets/category_icon.dart';
import 'package:linens/models/user_model.dart';
import 'package:linens/repository/user_repository.dart';
import '../Widgets/lokasi_kota.dart';
import '../Widgets/homescreen_custom_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final numberFormat = NumberFormat.decimalPattern('id');
  late Stream<UserModel> _userDataStream;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser!;
    _userDataStream = UserRepository().streamUserData(currentUser.email!);
  }

  Future<UserModel> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    UserRepository userRepository = UserRepository();
    return await userRepository.getUserDetails(currentUser.email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 150, 199),
        title: const Text(
          "BantuBangkit",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<UserModel>(
        stream: _userDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userModel = snapshot.data!;
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 16.0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, ${userModel.fullName}!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rp ${numberFormat.format(userModel.totalDonasi)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("Total Donasimu"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.emoji_people),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${numberFormat.format(userModel.jumlahDonasi)}x",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("Kali Donasi"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_balance_wallet),
                                        SizedBox(width: 5),
                                        Text(
                                            "Rp ${numberFormat.format(userModel.saldo)}"),
                                        SizedBox(width: 10),
                                        Text(
                                          "Isi Saldo",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 60, 150, 199),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.wechat_sharp),
                                      SizedBox(width: 5),
                                      Text("Kontak Kami"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Campaign Tercapai",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Aksi ketika "Lihat Semua" ditekan
                              },
                              child: const Text(
                                "Lihat Semua",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 60, 150, 199),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 320, // Sesuaikan dengan tinggi CustomCard
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('campaign')
                        .where('isVERIFIED', isEqualTo: true)
                        .orderBy(FieldPath.documentId, descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No campaigns found'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, index) {
                            var campaign = snapshot.data!.docs[index];
                            double progressValue =
                                campaign['dana_sedang_terkumpul'] /
                                    campaign['target_biaya_donasi'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomCard(
                                id: campaign.id,
                                imagePath: campaign['foto_url'],
                                judul: campaign['judul'],
                                pembuat: campaign['nama_sesuai_ktp'],
                                targetBiaya: campaign['target_biaya_donasi'],
                                cerita: campaign['cerita_kampanye'],
                                ajakan: campaign['ajakan'],
                                durasi: campaign['durasi'],
                                biayaTerkumpul:
                                    campaign['dana_sedang_terkumpul'],
                                progressValue: progressValue,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Kategori",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CategoryIcon(
                        icon: Icons.health_and_safety,
                        text: "Kesehatan",
                        backgroundColor: Color.fromARGB(255, 23, 117, 146),
                        destinationScreen: CategoryScreen(),
                      ),
                      CategoryIcon(
                        icon: Icons.broken_image,
                        text: "Bencana",
                        backgroundColor: Colors.blue,
                        destinationScreen: CategoryScreen(),
                      ),
                      CategoryIcon(
                        icon: Icons.school,
                        text: "Pendidikan",
                        backgroundColor: const Color.fromARGB(255, 23, 122, 26),
                        destinationScreen: CategoryScreen(),
                      ),
                      CategoryIcon(
                        icon: Icons.mosque,
                        text: "Tempat\nIbadah",
                        backgroundColor: Color.fromARGB(255, 39, 20, 148),
                        destinationScreen: CategoryScreen(),
                      ),
                      CategoryIcon(
                        icon: Icons.pets,
                        text: "Hewan",
                        backgroundColor: Color.fromARGB(255, 23, 117, 146),
                        destinationScreen: CategoryScreen(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cari Lokasi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(15, 2, 15, 10),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ImageWithOverlay(
                        imagePath: "images/jawa-timur.jpg",
                        overlayText: "Jawa Timur",
                      ),
                      SizedBox(width: 10),
                      ImageWithOverlay(
                        imagePath: "images/jawa-barat.jpg",
                        overlayText: "Jawa Barat",
                      ),
                      SizedBox(width: 10),
                      ImageWithOverlay(
                        imagePath: "images/bali.jpg",
                        overlayText: "Bali",
                      ),
                      SizedBox(width: 10),
                      ImageWithOverlay(
                        imagePath: "images/jawa-tengah.jpg",
                        overlayText: "Jawa Tengah",
                      ),
                      SizedBox(width: 10),
                      ImageWithOverlay(
                        imagePath: "images/jakarta.jpg",
                        overlayText: "Jakarta",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
