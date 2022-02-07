import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/Recommendations/freeRecommendations.dart';
import 'package:ahmad_pro/secreens/Recommendations/recommendations.dart';
import 'package:ahmad_pro/secreens/cart/cart.dart';
import 'package:ahmad_pro/services/homeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../sharedPreferences.dart';

class RecommendationsPages extends StatefulWidget {
  @override
  _RecommendationsPagesState createState() => _RecommendationsPagesState();
}

class _RecommendationsPagesState extends State<RecommendationsPages> {
  getTotalPrice() async {
    Cart.totalPraices = await MySharedPreferences.getTotalPrice();
    User.userLogIn = await MySharedPreferences.getUserSingIn();
    User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
    User.userBuyPlan = await MySharedPreferences.getUserBuyPlan();
    User.userCantBuy = await MySharedPreferences.getUserCantBuy();
    User.userPassword = await MySharedPreferences.getUserUserPassword();
    User.userToken = await MySharedPreferences.getUserToken();
  }

  @override
  void initState() {
    getTotalPrice();
    super.initState();
    print("UserSkiping LOgIN:${User.userSkipLogIn}");
  }

  @override
  Widget build(BuildContext context) {
    print("User.userSkipLogIn:${User.userSkipLogIn}");
    if (Provider.of<CheckUserSubscriptionsProvider>(context).isUserPayPaln) {
      return Recommendations();
    } else {
      return FreeRecommendations();
    }
  }
}
