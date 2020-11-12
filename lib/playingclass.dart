import 'package:flutter/cupertino.dart';

class Isplaying extends ChangeNotifier {
  bool isplaying;
  settofalse() {
    isplaying = false;
    notifyListeners();
  }

  settotrue() {
    isplaying = true;
    notifyListeners();
  }
}
