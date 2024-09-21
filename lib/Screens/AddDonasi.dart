import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/donasi_custom_card.dart';
import '../Screens/Add%20Donasi/NewDonation.dart';

class AddDonasiScreen extends StatelessWidget {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewDonationScreen()),
                  );
                },
                child: Text(
                  "Buat Galang Dana Baru",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.blue),
                  ),
                  elevation: 9,
                  shadowColor: Colors.lightBlueAccent.withOpacity(0.4),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('campaign').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No campaigns found'));
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.52, // Adjust this ratio as needed
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var campaign = snapshot.data!.docs[index];
                      double progressValue = campaign['dana_sedang_terkumpul'] /
                          campaign['target_biaya_donasi'];

                      return DonasiCustomCard(
                        id: campaign.id,
                        imagePath: campaign['foto_url'],
                        judul: campaign['judul'],
                        pembuat: campaign['nama_sesuai_ktp'],
                        targetBiaya: campaign['target_biaya_donasi'],
                        cerita: campaign['cerita_kampanye'],
                        ajakan: campaign['ajakan'],
                        durasi: campaign['durasi'],
                        biayaTerkumpul: campaign['dana_sedang_terkumpul'],
                        progressValue: progressValue,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
