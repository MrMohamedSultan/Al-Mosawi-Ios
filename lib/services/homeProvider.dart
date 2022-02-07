import 'package:flutter/material.dart';

class CheckUserSubscriptionsProvider with ChangeNotifier {
  bool isUserPayPaln = false;

  checkUserSubscriptions(bool isUserPayPaln) {
    this.isUserPayPaln = isUserPayPaln;
    notifyListeners();
  }
}
