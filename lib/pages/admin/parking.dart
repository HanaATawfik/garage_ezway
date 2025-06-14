import 'dart:io';
  import 'package:flutter/material.dart';
  import 'admin_home.dart'; // Fixed relative import
  import 'package:shared_preferences/shared_preferences.dart';
  import 'edit_parking.dart';

  class ParkingPage extends StatefulWidget {
    final File? profileImage; // Added to match AdminHomePage constructor

    const ParkingPage({super.key, this.profileImage});

    @override
    _ParkingPageState createState() => _ParkingPageState();
  }

  class _ParkingPageState extends State<ParkingPage> {
    String selectedItem = 'Parking';
    String parkingName = "DREAM PARKING";
    String parkingPrice = "20";
    String parkingLocation = "El zahr, 6 October, Giza";
    String parkingSlots = "90";
    String? parkingImagePath;
    File? _profileImage; // Added for profile image

    @override
    void initState() {
      super.initState();
      _loadParkingData();
      _profileImage = widget.profileImage; // Initialize profile image
    }

    Future<void> _loadParkingData() async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        parkingPrice = prefs.getString('parkingPrice') ?? "20";
        parkingLocation =
            prefs.getString('parkingLocation') ?? "El zahr, 6 October, Giza";
        parkingSlots = prefs.getString('parkingSlots') ?? "90";
        parkingImagePath = prefs.getString('parkingImagePath');
      });
    }

    Future<void> _saveParkingData() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('parkingPrice', parkingPrice);
      await prefs.setString('parkingLocation', parkingLocation);
      await prefs.setString('parkingSlots', parkingSlots);
      if (parkingImagePath != null) {
        await prefs.setString('parkingImagePath', parkingImagePath!);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFF25303B),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                ),
                child: _buildBackButton(context),
              ),

              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              color: Color(0xFF3A4A5A),
                              child: Center(
                                child: Icon(
                                  Icons.local_parking,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parkingName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2C37),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey[300], height: 20),
                                _buildInfoRow(
                                  Icons.monetization_on,
                                  "PRICE PER HOUR:",
                                  "$parkingPrice LE/h",
                                ),
                                SizedBox(height: 12),
                                _buildInfoRow(
                                  Icons.location_on,
                                  "LOCATION:",
                                  parkingLocation,
                                ),
                                SizedBox(height: 12),
                                _buildInfoRow(
                                  Icons.local_parking,
                                  "TOTAL SLOTS:",
                                  parkingSlots,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Color(0xFF1F2C37),
                        onPressed: () async {
                          final updatedData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditParkingPage(
                                    name: parkingName,
                                    price: parkingPrice,
                                    location: parkingLocation,
                                    slots: parkingSlots,
                                    imagePath: parkingImagePath,
                                  ),
                            ),
                          );

                          if (updatedData != null) {
                            setState(() {
                              parkingPrice = updatedData["price"];
                              parkingLocation = updatedData["location"];
                              parkingSlots = updatedData["slots"];
                              parkingImagePath = updatedData["imagePath"];
                            });
                            await _saveParkingData();
                          }
                        },
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildBackButton(BuildContext context) {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminHomePage(profileImage: _profileImage)),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          SizedBox(width: 12),
          Text(
            "Parking Details",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    Widget _buildInfoRow(IconData icon, String label, String value) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Color(0xFF1F2C37)),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1F2C37),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }