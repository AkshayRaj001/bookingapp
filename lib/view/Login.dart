/*
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/GetBrachProvider.dart';
import '../../Controller/apiUrl.dart';
import '../../Controller/appUpdateProvider.dart';
import '../../Controller/loginProvider.dart';
import '../../Model/userModel.dart';
import '../abouttheDevelopementTeam.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? deviceId;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isPasswordVisible = false;


  @override
  void initState() {
    super.initState();

    fetchDeviceId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Appupdateprovider>(context, listen: false)
          .checkForUpdate(context, ApiConstants.currentVersion);
    });
  }

  void _showFilterDialog(BuildContext context) {
    final branchProvider =
        Provider.of<GetBranchProviderController>(context, listen: false);
    List<dynamic> branchesData = branchProvider.branchList;

    String selectedBranch =
        branchesData.isNotEmpty ? branchesData[0]['branchName'] : '';
    String selectedSoId =
        branchesData.isNotEmpty ? branchesData[0]['SoId'].toString() : '';
    TextEditingController branchController =
        TextEditingController(text: selectedBranch);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Select Branch',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                textStyle:
                    const TextStyle(color: Colors.black, letterSpacing: .5),
              ),
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: branchController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select a Branch',
                      suffixIcon: PopupMenuButton<String>(
                        icon: Icon(Icons.arrow_drop_down),
                        onSelected: (String value) {
                          selectedSoId = value;
                          selectedBranch = branchesData.firstWhere((branch) =>
                              branch['SoId'].toString() == value)['branchName'];
                          branchController.text = selectedBranch;
                        },
                        itemBuilder: (BuildContext context) {
                          return branchesData
                              .map<PopupMenuItem<String>>((branch) {
                            return PopupMenuItem<String>(
                              value: branch['SoId'].toString(),
                              child: Text(
                                branch['branchName'],
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  textStyle: const TextStyle(
                                      color: Colors.black, letterSpacing: .5),
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                print("Selected Branch: $selectedBranch (SoId: $selectedSoId)");

                // Save selectedSoId in SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('soid', selectedSoId);
                await prefs.setString('Branch', selectedBranch);

                // Navigate to customer list page
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/customerlistPage',
                  (route) => false,
                );
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Apply",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                          letterSpacing: .5,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchDeviceId() async {
    String? id = await getDeviceId();
    if (id != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('deviceId', id);
    }

    if (mounted) {
      setState(() {
        deviceId = id;
        print("deviceId**********************$deviceId");
      });
    }
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return "Unsupported Platform";
  }

  void _GetSoBranchList(BuildContext context, String username) async {
    final authController =
        Provider.of<GetBranchProviderController>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();

    bool isInitialLoad = false;
    await prefs.setBool('isDataLoaded', isInitialLoad);

    // Save username into SharedPreferences
    await prefs.setString('savedUsername', username);

    print("Saved Username: $username");

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Lottie.asset(
            'assets/animation/Animation - 1737453369137.json',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    // Call API to get branch list
    await authController
        .getSoBranchList(GetSoBranchListModel(socode: username));

    Navigator.pop(context);
    print("authController loginMessage: ${authController.loginMessage}");

    if (authController.loginMessage != null) {
      if (authController.loginMessage == "Login Success!") {
        _showFilterDialog(context);
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Center(
              child: Text(
                'Login Failed',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: .5,
                ),
              ),
            ),
            content: Text(
              "Incorrect Username or Password",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
                letterSpacing: .5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  void _login(BuildContext context, String username, String password,
      String IMEInumber) async
  {
    final authController = Provider.of<AuthController>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();
    bool isInitialLoad = false;
    await prefs.setBool('isDataLoaded', isInitialLoad);
    print("isInitialLoad*************$isInitialLoad");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Lottie.asset(
            'assets/animation/Animation - 1737453369137.json',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    await authController.login(
      UserModel(
          usercode: _usernameController.value.text,
          password: _passwordController.value.text,
          IMEICode: "$deviceId"),
    );
    Navigator.pop(context);
    print("AUTHHHHHH${authController.loginMessage}");
    if (authController.loginMessage != null) {
      if (authController.loginMessage == "Login Success!") {
        _GetSoBranchList(context, "${_usernameController.text}");
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'Login Failed',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
                letterSpacing: .5,
              ),
            ),
            content: Text(
              "Incorrect Username or Password",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
                letterSpacing: .5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/img/backgroundimage.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DevelopmentTeamDetails(),
                                        ));
                                  },
                                  child: Center(
                                    child: Container(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.2,
                                      child: const Image(
                                        image: AssetImage(
                                            "assets/img/meetteamm.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Text(
                                "ESO nXT",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05,
                                  color: const Color(0xFF008080),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: screenWidth * 0.2,
                                width: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xFF598E7A),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/img/ic_launcher.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Powered by",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.020,
                                color: Color(0xFF008080),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Center(
                              child: Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.2,
                                child: const Image(
                                  image:
                                      AssetImage("assets/img/ciinfos-logo.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.08,
                        color: const Color(0xFF598E7A),
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Sign In to Continue",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        color: const Color(0xFF598E7A),
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                              Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send_to_mobile,
                          color: Color(0xFF008080),
                          size: 8,
                        ),
                        Text(
                          "LIVE ",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.030,
                            color: Color(0xFF008080),
                            letterSpacing: .5,
                          ),
                        ),

                      ],
                    ),
                  ),

                  // Username Field
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: TextField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                          color: Colors.white70,
                          letterSpacing: .5,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF77BBA2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),
                      ),
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                        color: Colors.white,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: TextField(
                      obscureText: !_isPasswordVisible,
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        _login(
                          context,
                          _usernameController.text, // Fix: Get actual text
                          _passwordController.text, // Fix: Get actual text
                          "",
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                          color: Colors.white70,
                          letterSpacing: .5,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(
                                () => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFF77BBA2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white70,
                        ),
                      ),
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                        color: Colors.white,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Login Button
                  GestureDetector(
                    onTap: () {
                      _login(
                        context,
                        _usernameController.text, // Fix: Get actual text
                        _passwordController.text, // Fix: Get actual text
                        "",
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF008080),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "LOGIN",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send_to_mobile,
                          color: Color(0xFF008080),
                          size: 8,
                        ),
                        Text(
                          "version: ${ApiConstants.currentVersion}",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.030,
                            color: Color(0xFF008080),
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
