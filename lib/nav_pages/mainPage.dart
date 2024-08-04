import 'package:flutter/material.dart';
import 'package:picleaf/nav_pages/aboutUs.dart';
import 'package:picleaf/nav_pages/camera.dart';
import 'package:picleaf/nav_pages/feedBack.dart';
import 'package:picleaf/nav_pages/home.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  List pages = [
    const homePage(),
    const cameraPage(),
    const AboutUsPage(),
    const FeedbackPage()
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'PicLeaf requires an internet connection to get the latest updates.',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1.0),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              )),
          backgroundColor: Color.fromRGBO(47, 79, 79, 1.0),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: const Color.fromRGBO(102, 204, 102, 1.0),
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromRGBO(47, 79, 79, 1.0),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ), //Home
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
            ),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.feedback,
            ),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}
