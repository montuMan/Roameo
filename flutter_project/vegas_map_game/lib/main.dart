import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import 'screens/splash_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Mapbox with your PUBLIC access token (for client apps)
  const String accessToken = 'pk.eyJ1IjoidmFuYWJoaWxhc2giLCJhIjoiY21qN2lwM3hmMDNzdzNmczhrOTg0azNyOCJ9.RUUMXKYnFEoLVCAf7LjwTg';
  MapboxOptions.setAccessToken(accessToken);
  
  runApp(const VegasMapGameApp());
}

class VegasMapGameApp extends StatelessWidget {
  const VegasMapGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Romeo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // Start with black Romeo splash screen
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber[400]!,
              Colors.orange[300]!,
              Colors.red[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  // Game Title
                  Text(
                    '🗺️',
                    style: TextStyle(fontSize: 60),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'BENGALURU MAP GAME',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore Indiranagar & Beyond',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  
                  // Start Game Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'START EXPLORING',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Instructions Button
                  TextButton(
                    onPressed: () {
                      _showInstructionsDialog(context);
                    },
                    child: Text(
                      'How to Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Play'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🎯 Objective:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Explore famous Bengaluru locations and earn points!\n'),
                
                Text('🎮 Controls:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• Tap anywhere on the map to move your character'),
                Text('• Tap on location markers to learn more about them'),
                Text('• Visit discovered locations to earn points\n'),
                
                Text('⚡ Energy System:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• Moving consumes energy based on distance'),
                Text('• Visiting locations restores some energy'),
                Text('• Use the refresh button to restore full energy\n'),
                
                Text('🏆 Achievements:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• Unlock special achievements for milestones'),
                Text('• Visit specific locations for bonus rewards'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }
}