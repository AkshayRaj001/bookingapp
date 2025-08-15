/*
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lightning_overlay/lightning_overlay.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as tx;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../Controller/paymentprovider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Model/CustomarModel.dart';
import 'PaymentSatatus.dart';

class Payment extends StatefulWidget {
  final String date;
  final int customerId;
  final int branchId;
  final String schemeType;
  final String soId;
  final String machineId;
  final String machineIP;
  final int iStatus;
  final int offLineFlag;
  final String name;
  final String address;
  final String mobilrno;
  final String avgAmount;
  final String joingdate;
  final String customer;
  final String customerCode;
  final String MultipleOf;

  const Payment({
    super.key,
    required this.date,
    required this.customerId,
    required this.branchId,
    required this.schemeType,
    this.soId = "0",
    required this.machineId,
    required this.machineIP,
    required this.iStatus,
    required this.offLineFlag,
    required this.name,
    required this.address,
    required this.avgAmount,
    required this.mobilrno,
    required this.joingdate,
    required this.customer,
    required this.customerCode,
    required this.MultipleOf,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final Location locationController = Location();
  late MapController mapController;
  LatLng? currentPosition;
  TextEditingController amountController = TextEditingController();
  String? errorText;
  final List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) => initializeMap());
  }

*/
/*  Future<String> getConnectionType() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    String connetion = connectivityResult.first.toString();
    print("connectivityResult***************$connectivityResult");
    print("connetion***************$connetion");

    switch (connetion) {
      case "ConnectivityResult.wifi":
        print("connetion***************$connetion");
        return 'wifi';
      case "ConnectivityResult.mobile":
        return 'mobile';
      case "ConnectivityResult.ethernet":
        return 'ethernet';
      case "ConnectivityResult.none":
      default:
        return 'none';
    }
  }*//*


  void showinternetconnectionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.wifi_off, color: Colors.red),
            SizedBox(width: 10),
            Text(
              "No Internet",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, int amount) async {
    print("keriiii");
    try {
*/
/*      String connectionType = await getConnectionType();
      print("Connected via: $getConnectionType");

      if (connectionType == 'none') {
        print("Connected via: $connectionType");
        showinternetconnectionDialog(
          context,
          "No internet connection. Please check Wi-Fi or Mobile Data.",
        );
        return;
      }

      // Optional: You can even show a message like "Connected via Wi-Fi" or "Mobile Data"
      print("Connected via: $connectionType");*//*


      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? soId = prefs.getString('soid');

      if (soId == null || soId.isEmpty) {
        showPaymentDialog(context, "No username found in SharedPreferences",
            Colors.red, "assets/animation/paimentfaild.json");
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: tx.Lottie.asset(
              'assets/animation/Animation - 1737453369137.json',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      var response = await Provider.of<PaymentProvider>(context, listen: false).payment(
        collectedAmount: amount.toString(),
        customerId: widget.customerId.toString(),
        branchId: widget.branchId.toString(),
        schemeType: widget.schemeType,
        soId: widget.soId.toString(),
        machineId: widget.machineId.toString(),
        machineIP: widget.machineIP,
        iStatus: widget.iStatus.toString(),
        offLineFlag: widget.offLineFlag.toString(),
      );

      if (response != null && response.containsKey("Result")) {
        //loding false
        List<dynamic> resultList = response["Result"];
        if (resultList.isNotEmpty && resultList[0] is Map<String, dynamic>) {
          String msg = resultList[0]["msg"].toString();
          String SlNo = resultList[0]["SlNo"].toString();
          String statusCode = resultList[0]["statuscode"].toString();

          if (statusCode == "200") {
            amountController.clear();

            var data = resultList[0];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentStatus(
                  memberName: data["MemberName"].toString(),
                  membershipNumber: data["MemberShipNo"].toString(),
                  joiningDate: data["JoiningDate"].toString(),
                  paymentDate: data["Date"].toString(),
                  salesOffice:
                      'Mumbai HQ', // You can update this if it's dynamic
                  previewAmount: '₹${data["PreviousAmount"]}',
                  paymentMode: data["PaymentMode"].toString(),
                  paymentAmount: '₹${data["PaymentAmount"]}',
                  paymentStatus: data["PaymentStatus"].toString() == "Success"
                      ? "Successful"
                      : "Failed",
                  totalAmount: '₹${data["TotalAmount"]}',
                  transactionId:
                      '#TXN${data["SlNo"].toString().split('.').first}',
                  NAvigation: "",
                ),
              ),
            );
          } else {
            showPaymentDialog(
              context,
              msg,
              Colors.red,
              "assets/animation/paimentfaild.json",
            );
          }
          return;
        }
      }
    } catch (e) {
      showPaymentDialog(context, "An error occurred: $e", Colors.red,
          "assets/animation/paimentfaild.json");
    }
  }

  void showPaymentDialog(BuildContext context, String message,
      Color backgroundColor, String animation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Payment Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: tx.Lottie.asset(
                animation,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              message,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ == 4);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted =
        await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
      mapController.move(currentPosition!, 15.0);
    }

    locationController.onLocationChanged.listen((newLocation) {
      if (newLocation.latitude != null && newLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(newLocation.latitude!, newLocation.longitude!);
        });
        mapController.move(currentPosition!, 15.0);
      }
    });
  }

  void showDetailsDialog(BuildContext context, int amount) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [Color(0xFF00A86B), Color(0xFF004D40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Top Icon
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Icon(Icons.payment, color: Colors.white, size: 40),
                    ),

                    const SizedBox(height: 16.0),

                    // Title
                    Text(
                      "Confirm Payment",
                      style: GoogleFonts.lato(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Payment details card
                    Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount:",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "\₹${amount.toStringAsFixed(2)}",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Text(
                            "Are you sure you want to proceed with the payment?",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, color: Colors.red),
                          label: Text(
                            "Cancel",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                          ),
                          onPressed: () {
                            _processPayment(context, amount);
                          },
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          label: Text(
                            "Pay Now",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
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

*/
/*  void showPaymentDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4CAF50),
                      Color(0xFF388E3C)
                    ] // Green for success
                    , // Red for failure
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Status Icon
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Title
                    Text(
                      "Payment Status",
                      style: GoogleFonts.lato(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Payment status message
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            msg,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    // Close Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 14.0),
                        elevation: 3,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close, color: Colors.green),
                      label: Text(
                        "Close",
                        style: GoogleFonts.lato(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
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
  }*//*


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF008080),
        title: Center(
          child: Text('Payment',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Img/2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Consumer<PaymentProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSummaryCard(widget.customer),
                    const SizedBox(height: 20),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal, width: 2),
                      ),
                      child: currentPosition == null
                          ? const Center(child: CircularProgressIndicator())
                          : FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                initialCenter:
                                    currentPosition ?? LatLng(0.0, 0.0),
                                initialZoom: 15.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: currentPosition!,
                                      width: 50,
                                      height: 50,
                                      child: const Icon(Icons.location_on,
                                          color: Colors.red, size: 36),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      textAlign: TextAlign.start, // Corrected text alignment
                      controller: amountController,
                      decoration: InputDecoration(
                        hintText: "Enter Amount",
                        errorText: errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            Icon(Icons.attach_money, color: Colors.teal),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Allows only numbers
                      ],
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                int amount =
                                    int.tryParse(amountController.text) ?? 0;
                                double multipleOf =
                                    double.tryParse(widget.MultipleOf) ??
                                        250; // Default to 250 if invalid

                                if (amount <= multipleOf - 1) {
                                  setState(() {
                                    errorText =
                                        "Amount must be greater than ${multipleOf.toInt()}.";
                                  });
                                } else if (amount % multipleOf != 0) {
                                  setState(() {
                                    errorText =
                                        "Amount must be a multiple of ${multipleOf.toInt()}.";
                                  });
                                } else if (amount >= 200001) {
                                  setState(() {
                                    errorText =
                                        "Amount must be less than 200000.";
                                  });
                                } else {
                                  setState(() {
                                    errorText = null;
                                  });
                                  showDetailsDialog(context, amount);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Pay Now',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(customer) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenHeight * 0.02,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Stack(
        children: [
// Use it in your widget
          Positioned(
            top: 0,
            right: 0,
            child: Lightning(
              useGesture: false,
              maxValue: 600,
              borderRadius: 15,
              repeat: true,
              delayDuration: const Duration(milliseconds: 300),
              direction: LightningDirection.leftToRight,
              pauseDuration: const Duration(milliseconds: 200),
              durationIn: const Duration(milliseconds: 300),
              durationOut: const Duration(milliseconds: 450),
              overlayColor: Colors.white.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(getSchemeImage(
                        widget.schemeType)), // Dynamic image selection
                  ),
                ),
                height: screenWidth * 0.2,
                width: screenWidth * 0.2,
                child: Transform.rotate(
                  angle: 45 * 3.141592653589793 / 180,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 10, left: 25, top: 20),
                    child: Text(
                      widget.schemeType,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.08,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person,
                      size: 30, color: Color(0xFF008080)),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.customerCode}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      _wbuildDetailRow(
                          Icons.account_circle, "Name", widget.name),
                      _wbuildDetailRow(Icons.phone, "Mobile", widget.mobilrno),
                      _wbuildDetailRow(Icons.monetization_on, "Avg Amount",
                          "\u20B9${widget.avgAmount}"),
                      _wbuildDetailRow(Icons.date_range, "Joining Date",
                          "${widget.joingdate}"),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getSchemeImage(String scheme) {
    switch (scheme) {
      case "BGD":
        return "assets/Img/BGD.png";
      case "CGP11A":
        return "assets/Img/CGP11A.png";
      case "CGP11":
        return "assets/Img/CGP11.png";
      case "DPP11":
        return "assets/Img/DPP11.png";
      default:
        return "assets/Img/default.png";
    }
  }
}

Widget _wbuildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
*/
