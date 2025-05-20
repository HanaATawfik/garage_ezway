import 'package:flutter/material.dart';

                                                            class BookSlotPage extends StatefulWidget {
                                                              @override
                                                              _BookSlotPageState createState() => _BookSlotPageState();
                                                            }

                                                            class _BookSlotPageState extends State<BookSlotPage> {
                                                              int currentFloor = 1;

                                                              @override
                                                              Widget build(BuildContext context) {
                                                                return Scaffold(
                                                                  backgroundColor: const Color(0xFF0F1E2F),
                                                                  body: SafeArea(
                                                                    child: Column(
                                                                      children: [
                                                                        // Header Section
                                                                        _Header(),

                                                                        // Main Content Section
                                                                        Expanded(
                                                                          child: _MainContent(
                                                                            currentFloor: currentFloor,
                                                                            onFloorChanged: (floor) {
                                                                              setState(() {
                                                                                currentFloor = floor;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
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
                                                                return Container(
                                                                  color: const Color(0xFF0F1E2F),
                                                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      IconButton(
                                                                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                      ),
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
                                                                      // Empty SizedBox to maintain centering
                                                                      SizedBox(width: 48),
                                                                    ],
                                                                  ),
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
                                                              final int currentFloor;
                                                              final Function(int) onFloorChanged;

                                                              _MainContent({required this.currentFloor, required this.onFloorChanged});

                                                              // First floor spaces - only 3 slots
                                                              final List<Map<String, dynamic>> firstFloorSpaces = [
                                                                {"id": "A1", "status": "Available"},
                                                                {"id": "B2", "status": "Reserved"},
                                                                {"id": "A3", "status": "Selected"},
                                                              ];

                                                              // Second floor spaces - only 2 slots
                                                              final List<Map<String, dynamic>> secondFloorSpaces = [
                                                                {"id": "C1", "status": "Available"},
                                                                {"id": "D2", "status": "Reserved"},
                                                              ];

                                                              @override
                                                              Widget build(BuildContext context) {
                                                                // Get the spaces for the current floor
                                                                final spaces = currentFloor == 1 ? firstFloorSpaces : secondFloorSpaces;

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
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 16),

                                                                      // Search bar
                                                                      TextField(
                                                                        decoration: InputDecoration(
                                                                          hintText: "Search for a slot",
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
                                                                            onPressed: currentFloor > 1
                                                                                ? () => onFloorChanged(currentFloor - 1)
                                                                                : null,
                                                                            icon: Icon(
                                                                              Icons.chevron_left,
                                                                              color: currentFloor > 1 ? Colors.white : Colors.white.withOpacity(0.3),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "${currentFloor}${currentFloor == 1 ? 'st' : 'nd'} Floor",
                                                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                                                          ),
                                                                          IconButton(
                                                                            onPressed: currentFloor < 2
                                                                                ? () => onFloorChanged(currentFloor + 1)
                                                                                : null,
                                                                            icon: Icon(
                                                                              Icons.chevron_right,
                                                                              color: currentFloor < 2 ? Colors.white : Colors.white.withOpacity(0.3),
                                                                            ),
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