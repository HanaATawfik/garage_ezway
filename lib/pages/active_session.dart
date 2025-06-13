import 'package:flutter/material.dart';
              import 'package:shared_preferences/shared_preferences.dart';
              import 'home_page.dart';
              import 'payment_page.dart';
              import 'parking_receipt_screen.dart';
              import 'dart:async';

              class ActiveSessionPage extends StatefulWidget {
                final String mallName;
                final int floor;
                final String slotId;

                const ActiveSessionPage({
                  super.key,
                  this.mallName = "Mall Parking",
                  this.floor = 1,
                  this.slotId = "A1",
                });

                @override
                _ActiveSessionPageState createState() => _ActiveSessionPageState();
              }

              class _ActiveSessionPageState extends State<ActiveSessionPage> {
                Timer? _timer;
                Duration _duration = const Duration();
                bool _isParkingActive = false;
                DateTime? _startTime;

                // Variables to store parking details
                late String _mallName;
                late int _floor;
                late String _slotId;

                @override
                void initState() {
                  super.initState();
                  _mallName = widget.mallName;
                  _floor = widget.floor;
                  _slotId = widget.slotId;
                  _checkActiveSession();
                }

                Future<void> _checkActiveSession() async {
                  final prefs = await SharedPreferences.getInstance();
                  final savedStart = prefs.getString('parking_start_time');

                  if (savedStart != null) {
                    _startTime = DateTime.tryParse(savedStart);

                    // Also load saved parking details
                    _mallName = prefs.getString('parking_mall_name') ?? widget.mallName;
                    _floor = prefs.getInt('parking_floor') ?? widget.floor;
                    _slotId = prefs.getString('parking_slot_id') ?? widget.slotId;

                    if (_startTime != null) {
                      _isParkingActive = true;
                      _startBackgroundTimer();
                    }
                  }
                }

                void _startBackgroundTimer() {
                  _timer?.cancel();
                  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    setState(() {
                      _duration = DateTime.now().difference(_startTime!);
                    });
                  });
                }

                Future<void> _startParking() async {
                  _startTime = DateTime.now();
                  final prefs = await SharedPreferences.getInstance();

                  // Save all parking details
                  await prefs.setString('parking_start_time', _startTime!.toIso8601String());
                  await prefs.setString('parking_mall_name', _mallName);
                  await prefs.setInt('parking_floor', _floor);
                  await prefs.setString('parking_slot_id', _slotId);

                  setState(() {
                    _isParkingActive = true;
                  });

                  _startBackgroundTimer();
                }

                Future<void> _endParking() async {
                  _timer?.cancel();
                  final prefs = await SharedPreferences.getInstance();

                  // Clear all saved parking data
                  await prefs.remove('parking_start_time');
                  await prefs.remove('parking_mall_name');
                  await prefs.remove('parking_floor');
                  await prefs.remove('parking_slot_id');

                  final sessionDuration = DateTime.now().difference(_startTime!);
                  final cost = _calculateCost(sessionDuration);

                  // Navigate back to home first to update the UI
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );

                  // Then show the receipt with the correct parameters
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingReceiptScreen(
                        mallName: _mallName,
                        floor: _floor,
                        slotId: _slotId,
                        startTime: _startTime!,
                        endTime: DateTime.now(),
                      ),
                    ),
                  );
                }

                double _calculateCost(Duration duration) {
                  final hours = duration.inMinutes / 60;
                  final roundedHours = hours.ceil();
                  if (roundedHours < 1) {
                    return 20.0; // Minimum charge for any session
                  }
                  return roundedHours * 20.0;
                }

                String _formatDuration(Duration duration) {
                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes % 60)}:${twoDigits(duration.inSeconds % 60)}";
                }

                String _formatDateTime(DateTime dateTime) {
                  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.day}/${dateTime.month}/${dateTime.year}";
                }

                String _getFloorText(int floor) {
                  if (floor == 1) return "1st Floor";
                  if (floor == 2) return "2nd Floor";
                  if (floor == 3) return "3rd Floor";
                  return "${floor}th Floor";
                }

                @override
                void dispose() {
                  _timer?.cancel();
                  super.dispose();
                }

                @override
                Widget build(BuildContext context) {
                  return Scaffold(
                    backgroundColor: const Color(0xFF0D1B2A),
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed:
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            ),
                      ),
                      centerTitle: true,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "ACTIVE SESSION",
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              _formatDuration(_duration),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Parking Details",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(color: Colors.white38),
                                Text(
                                  "From:   ${_startTime != null ? _formatDateTime(_startTime!) : 'Not started'}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  "Slot:   $_slotId, ${_getFloorText(_floor)}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  "Mall:   $_mallName",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                const Text(
                                  "Price per hour:   EGP 20.00",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_isParkingActive) {
                                  _endParking();
                                } else {
                                  _startParking();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isParkingActive ? Colors.redAccent : Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              child: Text(
                                _isParkingActive ? "End Parking" : "Start Parking",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                }
              }