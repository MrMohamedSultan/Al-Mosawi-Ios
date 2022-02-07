// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// class DashPurchases extends ChangeNotifier {
//   DashCounter counter;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   final iapConnection = IAPConnection.instance;

//   DashPurchases(this.counter) {
//     final purchaseUpdated =
//         iapConnection.purchaseStream;
//     _subscription = purchaseUpdated.listen(
//       _onPurchaseUpdate,
//       onDone: _updateStreamOnDone,
//       onError: _updateStreamOnError,
//     );
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   Future<void> buy(PurchasableProduct product) async {
//     // omitted
//   }

//   void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
//     // Handle purchases here
//   }

//   void _updateStreamOnDone() {
//     _subscription.cancel();
//   }

//   void _updateStreamOnError(dynamic error) {
//     //Handle error here
//   }
// }