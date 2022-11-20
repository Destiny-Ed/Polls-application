import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  set changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
