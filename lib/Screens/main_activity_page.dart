import 'package:flutter/material.dart';
import 'package:my_polls/Providers/authentication_provider.dart';
import 'package:my_polls/Providers/bottom_nav_provider.dart';
import 'package:my_polls/Screens/BottomNavPages/Account/accounts_page.dart';
import 'package:my_polls/Screens/BottomNavPages/Home/home_page.dart';
import 'package:my_polls/Screens/BottomNavPages/MyPolls/my_polls.dart';
import 'package:provider/provider.dart';

class MainActivityPage extends StatefulWidget {
  const MainActivityPage({super.key});

  @override
  State<MainActivityPage> createState() => _MainActivityPageState();
}

class _MainActivityPageState extends State<MainActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(builder: (context, nav, child) {
      return Scaffold(
        body: _pages[nav.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: nav.currentIndex,
          onTap: (value) {
            nav.changeIndex = value;
          },
        ),
      );
    });
  }

  List<Widget> _pages = [HomePage(), MyPolls(), AccountPage()];

  List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.poll), label: "My Polls"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Accounts"),
  ];
}
