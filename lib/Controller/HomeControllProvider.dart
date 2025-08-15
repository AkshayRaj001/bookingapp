import 'dart:async';
import 'package:flutter/material.dart';

import '../Model/DashboradModel.dart';


class HomeProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Workspace> experienceWorkspaces = [];
  List<Workspace> otherWorkspaces = [];

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Fake API data
    experienceWorkspaces = [
      Workspace(
        name: "Grand Workspace",
        location: "Kochi",
        image: "assets/img/edappalli.png",
        price: "₹1200/hr",
        rating: 4.5,
        avatars: [
          "assets/img/qvqtors.png",
          "assets/img/qvqtors.png",
          "assets/img/qvqtors.png",
        ],
      ),
      Workspace(
        name: "Sea View Co-working",
        location: "Goa",
        image: "assets/img/kakkanad.png",
        price: "₹1800/hr",
        rating: 4.8,
        avatars: [
          "assets/img/qvqtors.png",
          "assets/img/qvqtors.png",
        ],
      ),
    ];

    otherWorkspaces = [
      Workspace(
        name: "Skyline Workspace",
        location: "Mumbai",
        image: "assets/img/kaloor.png",
        price: "₹1500/hr",
        rating: 4.4,
      ),
      Workspace(
        name: "Palm Beach Co-working",
        location: "Chennai",
        image: "assets/img/kaloor.png",
        price: "₹2000/hr",
        rating: 4.7,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
