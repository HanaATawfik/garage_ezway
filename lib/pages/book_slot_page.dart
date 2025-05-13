import 'package:flutter/material.dart';

class BookSlotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E5F65),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _Header(),

            // Main Content Section
            Expanded(child: _MainContent()),
          ],
        ),
      ),
    );
  }
}

// ----------------------------
// HEADER
// ----------------------------
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar
        Container(
          color: const Color(0xFF2E5F65),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: Colors.white),
              Column(
                children: [
                  Text(
                    "GARAGE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "EZway",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Profile clicked — you can add navigation here if needed
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        // Menu bar
        Container(
          color: const Color(0xFF2E5F65),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TabItem(text: "HOME", isSelected: false, onTap: () {
                Navigator.pop(context); // Go back to HomePage
              }),
              _TabItem(text: "MY SESSION", isSelected: false),
              _TabItem(text: "HISTORY", isSelected: false),
              _TabItem(text: "SETTINGS", isSelected: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  _TabItem({required this.text, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}

// ----------------------------
// MAIN CONTENT
// ----------------------------
class _MainContent extends StatelessWidget {
  final List<Map<String, dynamic>> spaces = [
    {"id": "A1", "status": "Available"},
    {"id": "B1", "status": "Reserved"},
    {"id": "A2", "status": "Available"},
    {"id": "B2", "status": "Reserved"},
    {"id": "A3", "status": "Selected"},
    {"id": "B3", "status": "Available"},
    {"id": "A4", "status": "Available"},
    {"id": "B4", "status": "Reserved"},
    {"id": "A5", "status": "Available"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Section title
          Text(
            "CHOOSE SPACE",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Optional for a cleaner match
            ),
          ),
          SizedBox(height: 16),

          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: "A3/Floor 1",
              prefixIcon: Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Floor Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_left, color: Colors.white),
              ),
              Text(
                "1st Floor",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Parking Spaces Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: spaces.length,
              itemBuilder: (context, index) {
                var space = spaces[index];
                Color bgColor;
                if (space['status'] == 'Available') {
                  bgColor = Colors.white;
                } else if (space['status'] == 'Reserved') {
                  bgColor = Colors.grey[200]!;
                } else {
                  bgColor = Colors.white;
                }

                return Card(
                  color: bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car, size: 40, color: Colors.black),
                        SizedBox(height: 8),
                        Text(space['id'], style: TextStyle(fontSize: 18)),
                        Text(space['status'], style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),

          // Book Button
          ElevatedButton(
            onPressed: () {},
            child: Text("BOOK SELECTION"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF46B1A1),
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}