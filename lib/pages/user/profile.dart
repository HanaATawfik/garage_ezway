//profile.dart FIXED
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'edit_vehicle.dart';
import 'home_page.dart';
import 'payment.dart';
import 'personal_info.dart';
import 'change_password.dart';
import 'faq.dart';
import 'booking_history.dart';
import 'saved_cards_page.dart';
import 'payment_and_cards.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImageProvider? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');
    if (base64Image != null) {
      final imageBytes = base64Decode(base64Image);
      setState(() {
        _profileImage = MemoryImage(imageBytes);
      });
    } else {
      setState(() {
        _profileImage = const AssetImage(
          "assets/icons/abstract-user-flat-4.png",
        );
      });
    }
  }

  Future<void> _pickProfileImage() async {
    // Temporary placeholder until image_picker is available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker not available. Add image_picker package to pubspec.yaml')),
    );
  }

  Future<void> _removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
    setState(() {
      _profileImage = const AssetImage("assets/icons/abstract-user-flat-4.png");
    });
  }

  void _showImageOptions() {
    final bool hasCustomImage = _profileImage is MemoryImage;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.white),
              title: const Text(
                'Upload from gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickProfileImage();
              },
            ),
            if (hasCustomImage)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text(
                  'Remove profile picture',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfileImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E2F),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 30, 47),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildBackButton(context),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(radius: 50, backgroundImage: _profileImage),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showImageOptions,
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _profileOption(Icons.person, "Personal Information", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                }),
                _profileOption(Icons.car_rental, "Vehicles", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditVehicle(),
                    ),
                  );
                }),
                _profileOption(Icons.payment, "Payment & Cards", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentMethodPage(),
                    ),
                  );
                }),
                _profileOption(Icons.history, "History", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryPage(),
                    ),
                  );
                }),
                _profileOption(Icons.lock, "Change Your Password", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                }),
                _profileOption(Icons.help, "Support & Help Center", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  FAQPage()),
                  );
                }),
                const Divider(),
                _profileOption(Icons.exit_to_app, "Log Out", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                }, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileOption(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}