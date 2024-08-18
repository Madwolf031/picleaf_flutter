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
  final List<Widget> pages = [
    const homePage(),
    const cameraPage(),
    const AboutUsPage(),
    const FeedbackPage(),
  ];
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PicLeaf",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(102, 204, 102, 1.0),
        shadowColor: const Color(0xffeeeeee),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search, color: Colors.white),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: pages,
      ),
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
