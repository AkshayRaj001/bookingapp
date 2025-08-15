import 'package:flutter/material.dart';
import 'dart:async';

import '../Utils/BottomNavigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage(initialselectedtab: "0",initialTabIndex: 0,),))
;    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo in the center
          Center(
            child: Image.asset(
              'assets/img/inner.png', // Logo
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
