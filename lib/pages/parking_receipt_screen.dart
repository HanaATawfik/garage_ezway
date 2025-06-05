import 'package:flutter/material.dart';

                                          class ParkingReceiptScreen extends StatelessWidget {
                                            const ParkingReceiptScreen({Key? key}) : super(key: key);

                                            @override
                                            Widget build(BuildContext context) {
                                              return Scaffold(
                                                backgroundColor: const Color(0xFF121212), // dark theme
                                                appBar: AppBar(
                                                  backgroundColor: Colors.transparent,
                                                  elevation: 0,
                                                  title: const Text(
                                                    "Garage EZway",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  centerTitle: true,
                                                  automaticallyImplyLeading: false, // Remove default back button
                                                ),
                                                body: const _ReceiptBody(),
                                                bottomNavigationBar: _BottomPayButton(),
                                              );
                                            }
                                          }

                                          class _ReceiptBody extends StatelessWidget {
                                            const _ReceiptBody();

                                            @override
                                            Widget build(BuildContext context) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: GestureDetector(
                                                          onTap: () => Navigator.pop(context),
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.grey[700],
                                                            child: const Icon(Icons.chevron_left, color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 16),
                                                      const Text(
                                                        'TICKET',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      _ReceiptCard(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }

                                          class _ReceiptCard extends StatelessWidget {
                                            @override
                                            Widget build(BuildContext context) {
                                              return Card(
                                                color: Colors.grey[900],
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Center(
                                                        child: Text("PARKING RECEIPT", style: TextStyle(color: Colors.grey, fontSize: 18)),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Center(
                                                        child: Text("12/11/2024", style: TextStyle(color: Colors.grey)),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.local_parking, color: Colors.white),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: Text(
                                                              "Mall of Egypt Parking",
                                                              style: TextStyle(color: Colors.grey, fontSize: 16),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Text("FROM : 7:45 1/1/25",
                                                          style: TextStyle(color: Colors.grey),
                                                          overflow: TextOverflow.ellipsis),
                                                      Text("TO : 9:52 1/1/25",
                                                          style: TextStyle(color: Colors.grey),
                                                          overflow: TextOverflow.ellipsis),
                                                      Text("SLOT : A3 , Floor 1",
                                                          style: TextStyle(color: Colors.grey),
                                                          overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 20),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text("TOTAL: 24.00",
                                                            style: TextStyle(
                                                              color: Colors.grey[300],
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            )),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        color: Colors.grey[700],
                                                        alignment: Alignment.center,
                                                        child: const Text("|| ||| ||||| |", style: TextStyle(color: Colors.white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }

                                          class _BottomPayButton extends StatelessWidget {
                                            @override
                                            Widget build(BuildContext context) {
                                              return Container(
                                                margin: const EdgeInsets.all(16),
                                                child: ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.teal,
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  ),
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                                                  label: const Text("PAY TICKET", style: TextStyle(color: Colors.white, fontSize: 16)),
                                                ),
                                              );
                                            }
                                          }