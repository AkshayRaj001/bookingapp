import 'dart:async';
import 'package:flutter/material.dart';
import '../Model/DashboradModel.dart';

class Mybookingprovider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Workspace> bookings = [];

  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Fake API data
    bookings = [
      Workspace(
        name: "WorkHub - Mumbai",
        location: "Mumbai, India",
        image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800",
        price: "₹1200/hr",
        rating: 4.5,
        status: "Upcoming",
        date: "20 Aug 2025",
      ),
      Workspace(
        name: "SpaceWorks - Delhi",
        location: "Delhi, India",
        image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800",
        price: "₹1800/hr",
        rating: 4.8,
        status: "Completed",
        date: "10 Aug 2025",
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
