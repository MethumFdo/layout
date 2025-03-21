import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(toggleDarkMode: _toggleDarkMode, isDarkMode: _isDarkMode),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  final bool isDarkMode;

  HomeScreen({required this.toggleDarkMode, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _sugarController = TextEditingController();
  double? _userSugarLevel;
  double _averageSugarLevel = 110.0;
  double _lowerSugarLevel = 90.0;
  double _higherSugarLevel = 130.0;
  bool _isResultVisible = false;
  String _sugarLevelMessage = '';
  Color _messageColor = Colors.green;
  bool _isInputDialogVisible = false;

  void _submitSugarLevel() {
    setState(() {
      _userSugarLevel = double.tryParse(_sugarController.text);
      if (_userSugarLevel != null) {
        if (_userSugarLevel! < _averageSugarLevel - 10) {
          _sugarLevelMessage = 'Low sugar level detected!';
          _messageColor = Colors.blue;
        } else if (_userSugarLevel! > _averageSugarLevel + 10) {
          _sugarLevelMessage = 'High sugar level detected!';
          _messageColor = Colors.red;
        } else {
          _sugarLevelMessage = 'Sugar level is normal.';
          _messageColor = Colors.green;
        }
        _isResultVisible = true;
      }
    });
  }

  void _openInputDialog() {
    setState(() {
      _isInputDialogVisible = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Stack(
            children: [
              // Blurred Background
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              // Input Form in the Dialog
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter Your Sugar Level',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _sugarController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Sugar Level',
                        prefixIcon: Icon(FontAwesomeIcons.tint),
                        filled: true,
                        // To fill the background color
                        fillColor: Colors.white,
                        // Set the background color to white
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey
                              .shade400), // Light border for contrast
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors
                              .blueAccent), // Border when focused
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitSugarLevel();
                        Navigator.of(context).pop(); // Close the dialog
                        setState(() {
                          _isInputDialogVisible = false;
                        });
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
            'Health Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleDarkMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sugar Level Input Button
                GestureDetector(
                  onTap: _openInputDialog,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 10)
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Input Sugar Level',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Main Card to show average, low, and high sugar levels
                AnimatedOpacity(
                  opacity: _isResultVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(FontAwesomeIcons.heartbeat,
                                  color: Colors.redAccent),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Average: $_averageSugarLevel mg/dL',
                                    style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Low: $_lowerSugarLevel mg/dL',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blueAccent),
                                  ),
                                  Text(
                                    'High: $_higherSugarLevel mg/dL',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (_isResultVisible)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Level: $_userSugarLevel mg/dL',
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _messageColor),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _sugarLevelMessage,
                                  style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _messageColor),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bottom two containers for visual effects or extra actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomContainer('Exercise', Colors.greenAccent),
                    _buildBottomContainer('Diet', Colors.blueAccent),
                  ],
                ),
              ],
            ),
          ),
          // Blur Effect for the rest of the screen when input dialog is visible (excluding bottom navigation bar)
          if (_isInputDialogVisible)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: widget.isDarkMode ? Colors.black.withOpacity(0.9) : Colors
            .redAccent,
        buttonBackgroundColor: Colors.redAccent,
        height: 55,
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {},
        animationCurve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildBottomContainer(String title, Color color) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8)],
      ),
      child: Center(
        child: Text(
           title,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
