import 'package:flutter/material.dart';
import 'package:hwrs_app/constants.dart';
import 'package:hwrs_app/screens/about.dart';
import 'package:hwrs_app/screens/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List pages = [
    const MyHomePage(
      title: "Home",
    ),
    const About(),
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(
      () {
        currentIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        //title: const Center(child: Text("Smat Scanner")),
      ),
      body: pages[currentIndex],
      /* bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.black54,
        unselectedItemColor: const Color.fromARGB(104, 29, 29, 29),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)
              //icon: SvgPicture.asset("assets/icons/home2.svg"),
              ),
          BottomNavigationBarItem(label: "About", icon: Icon(Icons.info)
              //icon: SvgPicture.asset("assets/icons/home2.svg"),
              ),
        ],
      ), */
      //floatingActionButton: customCartButtom(context),
    );
  }
}
