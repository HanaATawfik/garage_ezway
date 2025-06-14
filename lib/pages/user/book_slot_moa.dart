import 'package:flutter/material.dart';
                                                                     import 'active_session.dart'; // Import for ActiveSessionPage

                                                                     class BookSlotMOAPage extends StatefulWidget {
                                                                       const BookSlotMOAPage({super.key});

                                                                       @override
                                                                       _BookSlotMOAPageState createState() => _BookSlotMOAPageState();
                                                                     }

                                                                     class _BookSlotMOAPageState extends State<BookSlotMOAPage> {
                                                                       int currentFloor = 1;
                                                                       String? selectedSlotId;
                                                                       int? selectedFloor;

                                                                       // First floor spaces - 8 slots with varied statuses
                                                                       final List<Map<String, dynamic>> firstFloorSpaces = [
                                                                         {"id": "A1", "status": "Available", "row": "A"},
                                                                         {"id": "A2", "status": "Reserved", "row": "A"},
                                                                         {"id": "A3", "status": "Occupied", "row": "A"},
                                                                         {"id": "A4", "status": "Available", "row": "A"},
                                                                         {"id": "A5", "status": "Reserved", "row": "A"},
                                                                         {"id": "A6", "status": "Available", "row": "A"},
                                                                         {"id": "A7", "status": "Occupied", "row": "A"},
                                                                         {"id": "A8", "status": "Occupied", "row": "A"},
                                                                       ];

                                                                       // Second floor spaces - 8 slots with varied statuses
                                                                       final List<Map<String, dynamic>> secondFloorSpaces = [
                                                                         {"id": "D1", "status": "Available", "row": "D"},
                                                                         {"id": "D2", "status": "Reserved", "row": "D"},
                                                                         {"id": "D3", "status": "Occupied", "row": "D"},
                                                                         {"id": "D4", "status": "Available", "row": "D"},
                                                                         {"id": "D5", "status": "Reserved", "row": "D"},
                                                                         {"id": "D6", "status": "Occupied", "row": "D"},
                                                                         {"id": "D7", "status": "Available", "row": "D"},
                                                                         {"id": "D8", "status": "Reserved", "row": "D"},
                                                                       ];

                                                                       void toggleSlot(String slotId) {
                                                                         setState(() {
                                                                           // Get current floor spaces
                                                                           final currentSpaces = currentFloor == 1 ? firstFloorSpaces : secondFloorSpaces;

                                                                           // Case 1: Tapping the already selected slot - unselect it
                                                                           if (selectedSlotId == slotId && selectedFloor == currentFloor) {
                                                                             for (var space in currentSpaces) {
                                                                               if (space["id"] == slotId && space["status"] == "Selected") {
                                                                                 space["status"] = "Available";
                                                                                 selectedSlotId = null;
                                                                                 selectedFloor = null;
                                                                                 break;
                                                                               }
                                                                             }
                                                                           }
                                                                           // Case 2: Selecting a new slot
                                                                           else {
                                                                             // First clear any previously selected slot on ANY floor
                                                                             if (selectedSlotId != null) {
                                                                               final previousSpaces = selectedFloor == 1 ? firstFloorSpaces : secondFloorSpaces;
                                                                               for (var space in previousSpaces) {
                                                                                 if (space["id"] == selectedSlotId && space["status"] == "Selected") {
                                                                                   space["status"] = "Available";
                                                                                   break;
                                                                                 }
                                                                               }
                                                                             }

                                                                             // Then select the new slot if it's available
                                                                             for (var space in currentSpaces) {
                                                                               if (space["id"] == slotId && space["status"] == "Available") {
                                                                                 space["status"] = "Selected";
                                                                                 selectedSlotId = slotId;
                                                                                 selectedFloor = currentFloor;
                                                                                 break;
                                                                               }
                                                                             }
                                                                           }
                                                                         });
                                                                       }

                                                                       @override
                                                                       Widget build(BuildContext context) {
                                                                         return Scaffold(
                                                                           backgroundColor: const Color(0xFF0F1E2F),
                                                                           body: Container(
                                                                             decoration: BoxDecoration(
                                                                               gradient: LinearGradient(
                                                                                 begin: Alignment.topCenter,
                                                                                 end: Alignment.bottomCenter,
                                                                                 colors: [Color(0xFF0F1E2F), Color(0xFF1A2A3F)],
                                                                               ),
                                                                             ),
                                                                             child: SafeArea(
                                                                               child: Column(
                                                                                 children: [
                                                                                   // Header Section
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
                                                                                       onSlotSelected: toggleSlot,
                                                                                       hasSelectedSlot: selectedSlotId != null,
                                                                                     ),
                                                                                   ),
                                                                                 ],
                                                                               ),
                                                                             ),
                                                                           ),
                                                                         );
                                                                       }
                                                                     }

                                                                     // Adding missing widget classes
                                                                     class _Header extends StatelessWidget {
                                                                       @override
                                                                       Widget build(BuildContext context) {
                                                                         return Container(
                                                                           color: Colors.transparent,
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

                                                                     class _MainContent extends StatelessWidget {
                                                                       final int currentFloor;
                                                                       final List<Map<String, dynamic>> spaces;
                                                                       final Function(int) onFloorChanged;
                                                                       final Function(String) onSlotSelected;
                                                                       final bool hasSelectedSlot;

                                                                       _MainContent({
                                                                         required this.currentFloor,
                                                                         required this.spaces,
                                                                         required this.onFloorChanged,
                                                                         required this.onSlotSelected,
                                                                         required this.hasSelectedSlot,
                                                                       });

                                                                       @override
                                                                       Widget build(BuildContext context) {
                                                                         // Get the current row letter based on floor
                                                                         final String rowLetter = currentFloor == 1 ? 'A' : 'D';

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
                                                                               SizedBox(height: 24),

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
                                                                               SizedBox(height: 20),

                                                                               // Position row differently based on floor
                                                                               Expanded(
                                                                                 child: Align(
                                                                                   // Left align for first floor, right align for second floor
                                                                                   alignment: currentFloor == 1
                                                                                       ? Alignment.centerLeft
                                                                                       : Alignment.centerRight,
                                                                                   child: Padding(
                                                                                     padding: EdgeInsets.only(
                                                                                       left: currentFloor == 1 ? 20 : 0,
                                                                                       right: currentFloor == 2 ? 20 : 0,
                                                                                     ),
                                                                                     child: _VerticalParkingColumn(
                                                                                       rowLetter: rowLetter,
                                                                                       spaces: spaces,
                                                                                       onSlotSelected: onSlotSelected,
                                                                                     ),
                                                                                   ),
                                                                                 ),
                                                                               ),

                                                                               SizedBox(height: 16),

                                                                               // Book Button - only enabled when a slot is selected
                                                                               ElevatedButton(
                                                                                 onPressed: hasSelectedSlot
                                                                                     ? () {
                                                                                         // Get the selected slot data
                                                                                         Map<String, dynamic>? selectedSlot;

                                                                                         for (var space in spaces) {
                                                                                           if (space["status"] == "Selected") {
                                                                                             selectedSlot = space;
                                                                                             break;
                                                                                           }
                                                                                         }

                                                                                         // Navigate to ActiveSessionPage
                                                                                         Navigator.push(
                                                                                           context,
                                                                                           MaterialPageRoute(
                                                                                             builder: (context) => ActiveSessionPage(
                                                                                               mallName: "Mall of Arabia",
                                                                                               floor: currentFloor,
                                                                                               slotId: selectedSlot?["id"] ?? "",
                                                                                             ),
                                                                                           ),
                                                                                         );
                                                                                       }
                                                                                     : null,
                                                                                 child: Text(
                                                                                   "BOOK SELECTION",
                                                                                   style: TextStyle(
                                                                                     fontWeight: FontWeight.bold,
                                                                                     fontSize: 16,
                                                                                   ),
                                                                                 ),
                                                                                 style: ElevatedButton.styleFrom(
                                                                                   backgroundColor: Color(0xFF46B1A1),
                                                                                   disabledBackgroundColor: Color(0xFF46B1A1).withOpacity(0.3),
                                                                                   minimumSize: Size(double.infinity, 50),
                                                                                   shape: RoundedRectangleBorder(
                                                                                     borderRadius: BorderRadius.circular(8),
                                                                                   ),
                                                                                 ),
                                                                               ),
                                                                             ],
                                                                           ),
                                                                         );
                                                                       }
                                                                     }

                                                                     class _VerticalParkingColumn extends StatelessWidget {
                                                                       final String rowLetter;
                                                                       final List<Map<String, dynamic>> spaces;
                                                                       final Function(String) onSlotSelected;

                                                                       _VerticalParkingColumn({
                                                                         required this.rowLetter,
                                                                         required this.spaces,
                                                                         required this.onSlotSelected,
                                                                       });

                                                                       @override
                                                                       Widget build(BuildContext context) {
                                                                         return Container(
                                                                           width: 180,
                                                                           decoration: BoxDecoration(
                                                                             border: Border(
                                                                               left: BorderSide(color: Colors.grey[700]!, width: 2),
                                                                               right: BorderSide(color: Colors.grey[700]!, width: 2),
                                                                             ),
                                                                           ),
                                                                           child: Column(
                                                                             children: [
                                                                               // Row header
                                                                               Padding(
                                                                                 padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                                                 child: Text(
                                                                                   "Row $rowLetter",
                                                                                   style: TextStyle(
                                                                                     color: Colors.white70,
                                                                                     fontWeight: FontWeight.bold,
                                                                                     fontSize: 20,
                                                                                   ),
                                                                                 ),
                                                                               ),

                                                                               // Parking slots
                                                                               Expanded(
                                                                                 child: ListView.builder(
                                                                                   physics: ClampingScrollPhysics(),
                                                                                   itemCount: spaces.length,
                                                                                   itemBuilder: (context, index) {
                                                                                     return _ParkingSlot(
                                                                                       space: spaces[index],
                                                                                       onTap: () => onSlotSelected(spaces[index]['id']),
                                                                                     );
                                                                                   },
                                                                                 ),
                                                                               ),
                                                                             ],
                                                                           ),
                                                                         );
                                                                       }
                                                                     }

                                                                     class _ParkingSlot extends StatelessWidget {
                                                                       final Map<String, dynamic> space;
                                                                       final VoidCallback onTap;

                                                                       _ParkingSlot({required this.space, required this.onTap});

                                                                       @override
                                                                       Widget build(BuildContext context) {
                                                                         final status = space['status'];
                                                                         final id = space['id'];

                                                                         // Define appearance based on status
                                                                         Widget slotIcon;
                                                                         Color textColor = Colors.white;
                                                                         Color? backgroundColor;
                                                                         BoxBorder? border;

                                                                         if (status == 'Available') {
                                                                           slotIcon = Icon(
                                                                             Icons.directions_car_outlined,
                                                                             color: Colors.white,
                                                                             size: 50,
                                                                           );
                                                                           border = Border(
                                                                             bottom: BorderSide(color: Colors.grey[800]!, width: 1),
                                                                           );
                                                                         } else if (status == 'Selected') {
                                                                           slotIcon = Icon(
                                                                             Icons.directions_car,
                                                                             color: Colors.green,
                                                                             size: 50,
                                                                           );
                                                                           textColor = Colors.green;
                                                                           backgroundColor = Colors.green.withOpacity(0.15);
                                                                           border = Border.all(color: Colors.green, width: 1);
                                                                         } else if (status == 'Occupied') {
                                                                           slotIcon = Icon(
                                                                             Icons.directions_car,
                                                                             color: Colors.red,
                                                                             size: 50,
                                                                           );
                                                                           textColor = Colors.red;
                                                                           backgroundColor = Colors.red.withOpacity(0.1);
                                                                           border = Border(
                                                                             bottom: BorderSide(color: Colors.grey[800]!, width: 1),
                                                                           );
                                                                         } else {
                                                                           slotIcon = Icon(
                                                                             Icons.directions_car,
                                                                             color: Colors.grey[400],
                                                                             size: 50,
                                                                           );
                                                                           textColor = Colors.grey[400]!;
                                                                           border = Border(
                                                                             bottom: BorderSide(color: Colors.grey[800]!, width: 1),
                                                                           );
                                                                         }

                                                                         return GestureDetector(
                                                                           onTap: status == 'Available' || status == 'Selected' ? onTap : null,
                                                                           child: Container(
                                                                             padding: EdgeInsets.symmetric(vertical: 18),
                                                                             margin: EdgeInsets.symmetric(vertical: 6),
                                                                             decoration: BoxDecoration(
                                                                               color: backgroundColor,
                                                                               border: border,
                                                                               borderRadius: status == 'Selected' ? BorderRadius.circular(8) : null,
                                                                               boxShadow: status == 'Selected'
                                                                                   ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)]
                                                                                   : null,
                                                                             ),
                                                                             child: Column(
                                                                               children: [
                                                                                 slotIcon,
                                                                                 SizedBox(height: 10),
                                                                                 Text(
                                                                                   id,
                                                                                   style: TextStyle(
                                                                                     color: textColor,
                                                                                     fontWeight: FontWeight.bold,
                                                                                     fontSize: 22,
                                                                                   ),
                                                                                 ),
                                                                                 SizedBox(height: 6),
                                                                                 Text(
                                                                                   status,
                                                                                   style: TextStyle(
                                                                                     color: textColor,
                                                                                     fontSize: 18,
                                                                                   ),
                                                                                 ),
                                                                               ],
                                                                             ),
                                                                           ),
                                                                         );
                                                                       }
                                                                     }