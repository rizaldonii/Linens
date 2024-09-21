import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linens/Pages/donasi_sekarang.dart'; // Sesuaikan path sesuai struktur proyek Anda

class DonasiDetailPage extends StatelessWidget {
  static const routeName = '/donasi-detail';

  final String id;

  DonasiDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'id');

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('campaign').doc(id).get(),
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

        // Extract data from snapshot
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        String judul = data['judul'] ?? '';
        String ajakan = data['ajakan'] ?? '';
        double progressValue = (data['dana_sedang_terkumpul'] ?? 0) /
            (data['target_biaya_donasi'] ?? 1);
        int biayaTerkumpul = data['dana_sedang_terkumpul'] ?? 0;
        String cerita = data['cerita_kampanye'] ?? '';
        int durasi = data['durasi'] ?? 0;
        String province =
            data['province'] ?? ''; // Sesuaikan dengan struktur Firestore Anda
        String kategori =
            data['kategori'] ?? ''; // Sesuaikan dengan struktur Firestore Anda
        String image = data['foto_url'] ?? '';

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: const Color.fromARGB(255, 60, 150, 199),
                title: const Text(
                  "BantuBangkit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            judul,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            ajakan,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 219, 219, 219),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 17,
                                      ),
                                      Text(
                                        province,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 219, 219, 219),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.category,
                                        size: 17,
                                      ),
                                      Text(
                                        kategori,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(height: 8),
                          Text("Dana Terkumpul"),
                          Text(
                            "Rp ${numberFormat.format(biayaTerkumpul)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            "Cerita: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            cerita,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Color.fromARGB(255, 60, 150, 199),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    PaymentDonasi.routeName,
                    arguments: id, // Mengirimkan idCampaign ke PaymentDonasi
                  );
                },
                child: Text(
                  'Donasi Sekarang',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
