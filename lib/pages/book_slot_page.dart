import 'package:flutter/material.dart';
  import 'Parking_Receipt_Screen.dart';

  class BookSlotPage extends StatefulWidget {
    @override
    _BookSlotPageState createState() => _BookSlotPageState();
  }

  class _BookSlotPageState extends State<BookSlotPage> {
    int currentFloor = 1;
    String? selectedSlotId;

    // First floor spaces
    final List<Map<String, dynamic>> firstFloorSpaces = [
      {"id": "A1", "status": "Available"},
      {"id": "B2", "status": "Reserved"},
      {"id": "A3", "status": "Available"},
    ];

    // Second floor spaces
    final List<Map<String, dynamic>> secondFloorSpaces = [
      {"id": "C1", "status": "Available"},
      {"id": "D2", "status": "Reserved"},
    ];

    void selectSlot(String slotId) {
      setState(() {
        // If there was a previously selected slot, change it back to Available
        if (selectedSlotId != null) {
          final spaces = currentFloor == 1 ? firstFloorSpaces : secondFloorSpaces;
          for (var space in spaces) {
            if (space["id"] == selectedSlotId && space["status"] == "Selected") {
              space["status"] = "Available";
            }
          }
        }

        // Update the new selected slot
        final spaces = currentFloor == 1 ? firstFloorSpaces : secondFloorSpaces;
        for (var space in spaces) {
          if (space["id"] == slotId && space["status"] == "Available") {
            space["status"] = "Selected";
            selectedSlotId = slotId;
          }
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F1E2F),
        body: SafeArea(
          child: Column(
            children: [
              // Header Section - Simplified
              _Header(),

              // Main Content Section
              Expanded(
                child: _MainContent(
                  currentFloor: currentFloor,
                  spaces: currentFloor == 1 ? firstFloorSpaces : secondFloorSpaces,
                  onFloorChanged: (floor) {
                    setState(() {
                      currentFloor = floor;
                    });
                  },
                  onSlotSelected: selectSlot,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Simplified Header - removed logo
  class _Header extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Container(
        color: const Color(0xFF0F1E2F),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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

  // Modified MainContent - removed search bar
  class _MainContent extends StatelessWidget {
    final int currentFloor;
    final List<Map<String, dynamic>> spaces;
    final Function(int) onFloorChanged;
    final Function(String) onSlotSelected;

    _MainContent({
      required this.currentFloor,
      required this.spaces,
      required this.onFloorChanged,
      required this.onSlotSelected,
    });

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
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24), // Increased spacing since search bar is removed

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
                  Color textColor = Colors.black;

                  if (space['status'] == 'Available') {
                    bgColor = Colors.white;
                  } else if (space['status'] == 'Reserved') {
                    bgColor = Colors.grey[300]!;
                    textColor = Colors.black54;
                  } else if (space['status'] == 'Selected') {
                    bgColor = Colors.green; // Green background for selected
                    textColor = Colors.white; // White text for better contrast
                  } else {
                    bgColor = Colors.white;
                  }

                  return GestureDetector(
                    onTap: space['status'] == 'Available'
                        ? () => onSlotSelected(space['id'])
                        : null,
                    child: Card(
                      color: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_car, size: 40, color: textColor),
                            SizedBox(height: 8),
                            Text(space['id'],
                                style: TextStyle(fontSize: 18, color: textColor)),
                            Text(space['status'],
                                style: TextStyle(fontSize: 14, color: textColor)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Book Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingReceiptScreen(),
                  ),
                );
              },
              child: Text("BOOK SLOT"),
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