import 'package:bookingapp/view/BookingScreen.dart';
import 'package:bookingapp/view/MyBookingScreen.dart';
import 'package:bookingapp/view/NotificationScreen.dart';
import 'package:bookingapp/view/SpaceDetailsScreen.dart';
import 'package:bookingapp/view/splashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/HomeControllProvider.dart';
import 'Controller/MyBookingProvider.dart';
import 'view/HomeScreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()..fetchHomeData()),
        ChangeNotifierProvider(create: (_) => Mybookingprovider()..fetchBookings()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) =>  HomeScreen(),
        '/booking': (context) => const BookingScreen(),
        '/my-bookings': (context) => const MyBookingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
