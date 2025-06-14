import 'dart:io';
  import 'package:flutter/material.dart';
  import 'admin_home.dart';
  import 'daily_earnings.dart';
  import '../user/login.dart';
  import 'parking.dart';
  import 'admin_change_password.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class AdminProfilePage extends StatefulWidget {
    final File? profileImage;

    const AdminProfilePage({super.key, this.profileImage});

    @override
    _AdminProfilePageState createState() => _AdminProfilePageState();
  }

  class _AdminProfilePageState extends State<AdminProfilePage> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    String selectedItem = 'Profile';
    File? _profileImage;

    @override
    void initState() {
      super.initState();
      _loadProfileImage();
    }

    Future<void> _loadProfileImage() async {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('adminProfileImagePath');
      if (imagePath != null && File(imagePath).existsSync()) {
        setState(() {
          _profileImage = File(imagePath);
        });
      } else {
        _profileImage = widget.profileImage;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(),
        backgroundColor: Color(0xFF25303B),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xFF25303B),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 26),
                onPressed: () => Navigator.pop(context, _profileImage),
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              pinned: true,
              floating: false,
              snap: false,
              elevation: 0,
              expandedHeight: 0,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileCard(),
                  SizedBox(height: 24),
                  _buildSettingsSection(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDrawer() {
      return Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F2C37), Color(0xFF3B4C5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1F2C37), Color(0xFF3B4C5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  "Admin Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text("admin@garageezway.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey[400] ?? Colors.grey,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Icon(Icons.person, color: Colors.white, size: 40)
                      : null,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(Icons.home, 'Home', context),
                    _buildDrawerItem(Icons.local_parking, 'Parking', context),
                    _buildDrawerItem(Icons.attach_money, 'Daily Earning', context),
                    _buildDrawerItem(Icons.person, 'Profile', context),
                  ],
                ),
              ),
              Divider(color: Colors.white54),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade400),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildProfileCard() {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.black26,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF25303B),
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Icon(Icons.person, color: Colors.white, size: 70)
                      : null,
                ),
                SizedBox(height: 20),
                Text(
                  "Admin Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "admin@garageezway.com",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700] ?? Colors.grey),
                ),
                SizedBox(height: 24),
                Divider(height: 1, color: Colors.grey[300] ?? Colors.grey.shade300),
                SizedBox(height: 16),
                _buildProfileInfoRow(Icons.phone, "Phone", "+20 123 456 7890"),
                _buildProfileInfoRow(
                  Icons.location_on,
                  "Address",
                  "6 October City, Giza, Egypt",
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildProfileInfoRow(IconData icon, String label, String value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF25303B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Color(0xFF3B4C5C), size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600] ?? Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildSettingsSection() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.black26,
          child: Column(
            children: [
              _buildSettingsItem(
                Icons.lock_outline,
                "Change Password",
                "Update your account password",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                },
              ),
              Divider(height: 1, indent: 16, endIndent: 16),
            ],
          ),
        ),
      );
    }

    Widget _buildSettingsItem(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
    ) {
      return ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF25303B).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF3B4C5C)),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600] ?? Colors.grey),
        ),
        trailing: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(0xFF25303B).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.chevron_right, color: Color(0xFF3B4C5C)),
        ),
        onTap: onTap,
      );
    }

    Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
      bool isActive = selectedItem == title;
      return ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isActive,
        selectedTileColor: Color(0xFF25303B).withOpacity(0.3),
        onTap: () {
          setState(() => selectedItem = title);
          Navigator.pop(context);

          if (title == 'Home') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(profileImage: _profileImage),
              ),
            );
          } else if (title == 'Parking') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ParkingPage()),
            );
          } else if (title == 'Daily Earning') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EarningsPage()),
            );
          }
        },
      );
    }
  }