import 'package:ahmad_pro/secreens/checkOut/components/creatVisaCard.dart';
import 'package:flutter/material.dart';

Future createVisaCard(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => AddFileBottomSheet(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    isScrollControlled: true,
  );
}
