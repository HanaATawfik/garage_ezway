import 'dart:io';
    import 'dart:math';
    import 'package:flutter/material.dart';
    import 'package:shared_preferences/shared_preferences.dart';
    import 'package:fl_chart/fl_chart.dart';

    // Fixed imports
    import 'admin_profile.dart';
    import 'daily_earnings.dart';
    import 'parking.dart';
    import '../user/login.dart'; // Updated path to the login screen

    class AdminHomePage extends StatefulWidget {
      final File? profileImage;

      const AdminHomePage({super.key, this.profileImage});

      @override
      _AdminHomePageState createState() => _AdminHomePageState();
    }

    class _AdminHomePageState extends State<AdminHomePage> {
      String selectedItem = 'Home';
      File? _profileImage;
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

      @override
      void initState() {
        super.initState();
        _loadProfileImage();
      }

      void _loadProfileImage() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? imagePath = prefs.getString('admin_image_path');
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
          drawer: Drawer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1F2C37), Color(0xFF3B4C5C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[400] ?? Colors.grey,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, color: Colors.white, size: 40)
                            : null,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Admin Name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildDrawerItem(Icons.home, 'Home', context),
                _buildDrawerItem(Icons.local_parking, 'Parking', context),
                _buildDrawerItem(Icons.attach_money, 'Daily Earning', context),
                Spacer(),
                _buildLogoutButton(context),
                SizedBox(height: 20),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Color(0xFF25303B),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white, size: 33),
            title: Text(
              'GARAGE EZway',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminProfilePage(profileImage: _profileImage),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _profileImage = result;
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('admin_image_path', result.path);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[400] ?? Colors.grey,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(Icons.person, color: Colors.white, size: 28)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF25303B),
          body: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildChartCard(dailyReservationsChart(), title: "Daily Reservations"),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildChartCard(monthlyParkingRevenueChart(), title: "Monthly Parking Revenue"),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _buildChartCard(monthlyReservationsChart(), title: "Monthly Reservations"),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
        bool isActive = selectedItem == title;

        return InkWell(
          onTap: () {
            setState(() {
              selectedItem = title;
            });

            Navigator.pop(context);
            if (title == 'Home') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminHomePage(profileImage: _profileImage)),
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
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF1F2C37) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Icon(icon, color: isActive ? Colors.white : Color(0xFF758283)),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : Color(0xFF758283),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildLogoutButton(BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, color: Colors.red.shade600, size: 26),
                  SizedBox(width: 6),
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      Widget _buildChartCard(Widget chart, {required String title}) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 30),
                SizedBox(height: 180, child: chart),
              ],
            ),
          ),
        );
      }

      Widget dailyReservationsChart() {
        return BarChart(
          BarChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: _weekDays,
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 20,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    );
                  },
                ),
              ),
            ),
            maxY: 100,
            barGroups: List.generate(7, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: Random().nextDouble() * 100,
                    color: Color(0xFF00CFC8),
                    width: 22,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }),
          ),
        );
      }

      Widget monthlyParkingRevenueChart() {
        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey[300] ?? Colors.grey.shade300,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: _months,
                  reservedSize: 30,
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 20,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 11, color: Colors.black),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  12,
                  (index) => FlSpot(index.toDouble(), Random().nextInt(30).toDouble() + 0),
                ),
                isCurved: true,
                color: Colors.black,
                barWidth: 3,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: true),
              ),
            ],
            maxY: 100,
          ),
        );
      }

      Widget monthlyReservationsChart() {
        return BarChart(
          BarChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey[300] ?? Colors.grey.shade300,
                strokeWidth: 0.8,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: _months,
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 20,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
            maxY: 100,
            barGroups: List.generate(12, (index) {
              return BarChartGroupData(
                x: index,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: Random().nextDouble() * 100,
                    color: Colors.black,
                    width: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),
          ),
        );
      }

      Widget _months(double value, TitleMeta meta) {
        List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 6,
          child: Transform.rotate(
            angle: -pi / 15,
            child: Text(
              months[value.toInt()],
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
        );
      }

      Widget _weekDays(double value, TitleMeta meta) {
        List<String> days = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 8,
          child: Text(
            days[value.toInt()],
            style: TextStyle(fontSize: 14, color: Colors.black)
          ),
        );
      }
    }