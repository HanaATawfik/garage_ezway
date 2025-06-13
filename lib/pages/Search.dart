import 'package:flutter/material.dart';
import 'book_slot_page.dart';
import 'home_page.dart';

class SearchMapPage extends StatelessWidget {
  const SearchMapPage({super.key});

  final List<Map<String, dynamic>> malls = const [
    {"name": "Mall of Arabia"},
    {"name": "City Stars"},
    {"name": "Cairo Festival City Mall"},
    {"name": "Maquette"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: malls.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(malls[index]["name"] ?? ""),
                    leading: const Icon(Icons.location_city),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  BookSlotPage(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(
                    "Navigate Available Malls",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
