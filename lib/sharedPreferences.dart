import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static String sharedPrefUserSinginKey = 'IsSingIn';
  static String sharedPrefBuyplan = 'IsBuyPlan';
  static String sharedPrefUserSkipLogIn = 'SkipLogIn';
  static String sharedPrefUserOnBording = 'OnBording';
  static String sharedPrefCantBuy = 'CantBuy';
  static String sharedPrefUserLat = 'Lat';
  static String sharedPrefTotalPraic = 'TotalPraic';
  static String sharedPrefUserLong = 'Long';
  static String sharedPrefUserselectedProImage = 'IsSelected';
  static String sharedPrefAppLang = 'AppLan';
  static String sharedPrefproChat = 'proChat';
  static String sharedPrefUserUserEmail = 'UserEmail';
  static String sharedPrefUserCourses = 'Courses';
  static String sharedPrefUserRecomendations = 'Recomendations';
  static String sharedPrefUserUserStutes = 'UserStuts';
  static String sharedPrefUserUserPhone = 'UserPhome';
  static String sharedPrefUserUserPassword = 'UserPassword';
  static String sharedPrefUserImageUrl = 'userImageUrl';
  static String sharedPrefUserid = 'userid';
  static String sharedPrefUserToken = 'userToken';
  static String sharedPrefCartConslProdect = 'cartConsulPro';
  static String sharedPrefCounsultFillterIndex = 'FillterIndex';
  static String sharedPrefCounsultFillterType = 'FillterType';
  //save data
  static Future<bool> saveUserSingIn(bool isSingin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefUserSinginKey, isSingin);
  }

  static Future<bool> saveUserPayPlan(bool isBuyPaln) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefBuyplan, isBuyPaln);
  }

  static Future<bool> saveUserSkipLogIn(bool isSkipLogIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefUserSkipLogIn, isSkipLogIn);
  }

  static Future<bool> saveUserOnBording(bool isOnBording) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefUserOnBording, isOnBording);
  }

  static Future<bool> saveUserCantBuy(bool isCantBuy) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefCantBuy, isCantBuy);
  }

  static Future<bool> saveUserselectedProImage(bool isSelected) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPrefUserselectedProImage, isSelected);
  }

  static Future<bool> saveUserproChat(String proChat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefproChat, proChat);
  }

  static Future<bool> saveUserToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserToken, token);
  }

  static Future<bool> saveFilltterIndex(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(sharedPrefCounsultFillterIndex, index);
  }

  static Future<bool> saveTotalPrice(double price) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setDouble(sharedPrefTotalPraic, price);
  }

  static Future<bool> saveFilltterType(String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefCounsultFillterType, type);
  }

  static Future<bool> saveUserlat(String lat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserLat, lat);
  }

  static Future<bool> saveUserlong(String long) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserLong, long);
  }

  static Future<bool> saveUserUserPassword(String userPasswrod) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPrefUserUserPassword, userPasswrod);
  }

  static Future<bool> saveUserUserid(int userid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(sharedPrefUserid, userid);
  }

  static Future<bool> saveAppLang(String appLang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefAppLang, appLang);
  }

  static Future<bool> saveUserUserEmail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserUserEmail, userEmail);
  }

  static Future<bool> saveUserCourses(String courses) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserCourses, courses);
  }

  static Future<bool> saveUserUserRecomendations(
      String userRecomendations) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPrefUserRecomendations, userRecomendations);
  }

  static Future<bool> saveUserUserStutas(String userStutes) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserUserStutes, userStutes);
  }

  static Future<bool> saveUserUserPhoneNumber(String userPhoneNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPrefUserUserPhone, userPhoneNumber);
  }

  static Future<bool> saveUserImageUrl(String userImageUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserImageUrl, userImageUrl);
  }

  // getdata
  static getUserSingIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isSingin = (preferences.getBool(sharedPrefUserSinginKey) ?? false);
    return isSingin;
  }

  static getUserCantBuy() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var cantBuy = (preferences.getBool(sharedPrefCantBuy));
    return cantBuy;
  }

  static getUserBuyPlan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var buyPlan = (preferences.getBool(sharedPrefBuyplan) ?? false);
    return buyPlan;
  }

  static getUserSkipLogIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isSkipLogIn = (preferences.getBool(sharedPrefUserSkipLogIn));
    return isSkipLogIn;
  }

  static getUserOnBording() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isOnBording = (preferences.getBool(sharedPrefUserOnBording));
    return isOnBording;
  }

  static getUserselectedProImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isSelected =
        (preferences.getBool(sharedPrefUserselectedProImage) ?? false);
    return isSelected;
  }

  static getUserproChat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String proChat = preferences.getString(sharedPrefproChat);
    return proChat;
  }

  static getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(sharedPrefUserToken);
    return token;
  }

  static getFiltterIndex() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int index = preferences.getInt(sharedPrefCounsultFillterIndex);
    return index;
  }

  static getTotalPrice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double price = (preferences.getDouble(sharedPrefTotalPraic) ?? 0.0);
    return price;
  }

  static getFiltterType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String type = preferences.getString(sharedPrefCounsultFillterType);
    return type;
  }

  static getUserLat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String lat = preferences.getString(sharedPrefUserLat);
    return lat;
  }

  static getUserlong() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String long = preferences.getString(sharedPrefUserLong);
    return long;
  }

  static getUserUserPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String password = preferences.getString(sharedPrefUserUserPassword);
    return password;
  }

  static getUserUserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int id = preferences.getInt(sharedPrefUserid);
    return id;
  }

  static getAppLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLang = preferences.getString(sharedPrefAppLang) ?? 'ar_EG';
    return appLang;
  }

  static getUserUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = preferences.getString(sharedPrefUserUserEmail);
    return email;
  }

  static getuserImageUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userImageUrl = preferences.getString(sharedPrefUserImageUrl);
    return userImageUrl;
  }

  static getUserCourses() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userCourses = preferences.getString(sharedPrefUserCourses);
    return userCourses;
  }

  static getUserRecomendations() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userRecomendations =
        preferences.getString(sharedPrefUserRecomendations);
    return userRecomendations;
  }

  static getUserUserStutes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String age = preferences.getString(sharedPrefUserUserStutes);
    return age;
  }

  static getUserUserPhoneNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String phoneNamber = preferences.getString(sharedPrefUserUserPhone);
    return phoneNamber;
  }
}
