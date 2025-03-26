import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E5F65), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Removes shadow
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // ☰ Menu Icon
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 30), // User Profile Icon
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LOGO "Garage EzWay"
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Garage EzWay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Navigation Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Home", style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("My Session", style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("History", style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("Settings", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search Parking Area",
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // "My Vehicle" Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // 50% faded white box
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  // "My Vehicle" Label (Top Left)
                  const Positioned(
                    top: 5,
                    left: 5,
                    child: Text(
                      "My Vehicle",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Car Name (Bold, Centered)
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Car Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Edit Icon (Small, Top Right)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                      onPressed: () {},
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
}
