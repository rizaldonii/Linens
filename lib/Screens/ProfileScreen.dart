import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linens/Screens/Profile%20Screen/EditProfile.dart';
import 'package:linens/features/global/toast.dart';
import 'package:linens/features/user_auth/LoginScreen.dart';
import 'package:linens/models/user_model.dart';
import 'package:linens/repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<void> _refreshUser() async {
    setState(() {
      _userFuture = _fetchUserData();
    });
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
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userModel = snapshot.data!;
            return RefreshIndicator(
                onRefresh: _refreshUser,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: userModel
                                                    .profileImageUrl !=
                                                null &&
                                            userModel
                                                .profileImageUrl!.isNotEmpty
                                        ? NetworkImage(
                                            userModel.profileImageUrl!)
                                        : AssetImage("images/default-image.jpg")
                                            as ImageProvider,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          userModel.fullName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          userModel.email,
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text("0"),
                            SizedBox(width: 10),
                            Text(
                              "Isi Saldo",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 60, 150, 199),
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ProfileSettings(
                          title: 'Edit Profil',
                          leadingIcon: Icons.account_circle_rounded,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile())),
                        ),
                        ProfileSettings(
                          title: 'Campaign Saya',
                          leadingIcon: Icons.inventory_2,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile())),
                        ),
                        ProfileSettings(
                            title: 'Favorit Saya',
                            leadingIcon: Icons.bookmark,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()))),
                        Divider(),
                        ProfileSettings(
                            title: 'Tentang Kami',
                            leadingIcon: Icons.group,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()))),
                        ProfileSettings(
                            title: 'FAQ',
                            leadingIcon: Icons.question_mark_rounded,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()))),
                        ProfileSettings(
                            title: 'Kontak Kami',
                            leadingIcon: Icons.chat_bubble_rounded,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()))),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (route) => false);
                                showToast(message: "Berhasil logout");
                              },
                              child: Text(
                                "Keluar",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10)
                  ],
                ));
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}

class ProfileSettings extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final void Function()? onTap;

  const ProfileSettings({
    Key? key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      leading: Icon(
        leadingIcon,
        size: 30,
      ),
      onTap: onTap,
    );
  }
}
