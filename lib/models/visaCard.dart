import 'package:flutter/cupertino.dart';

class VisaCard {
  final String cardNumber;
  final String exDate;
  final String cVV;
  final int index;

  VisaCard({
    @required this.cardNumber,
    @required this.exDate,
    @required this.cVV,
    @required this.index,
  });
}

class Helper {
  static String chossenDate = '';
  static bool status = false;
  static int cardConut = 0;
  static int tappedBottomShet = 0;

  static List<VisaCard> visaCardList = [];
}
