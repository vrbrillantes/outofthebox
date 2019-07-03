import 'package:shared_preferences/shared_preferences.dart';
import 'util.login.dart';
import 'util.firebase.dart';
class AppPreferences {
  static const String currentVersion = "3.0.1.60";
  static SharedPreferences prefs;

  static void checkVersion(void isUpdated(bool s)) {
    FirebaseMethods.getAppVersion((String s) {
      print(s + " APP VERSION");
      s == currentVersion ? isUpdated(true) : isUpdated(false);
    });
  }
  static void getDelivery(List<String> deliveryFields, String userKey, void onData(Map deliveryDetails)) async {
    prefs = await SharedPreferences.getInstance();
    Map deliveryDetails = {};
    deliveryFields.forEach((String s) async {
      String retrieved = await prefs.get(s + userKey);

      retrieved == null ? null : deliveryDetails[s] = retrieved;
      if (deliveryFields.length == deliveryDetails.length) {
        onData(deliveryDetails);
      }
    });
  }

  static void saveDelivery(Map deliveryDetails, void done()) {
    LoginFunctions.getUserName((String userID) async {
      prefs = await SharedPreferences.getInstance();
      deliveryDetails.forEach((key, value) async {
        await prefs.setString(key + userID, value);
        deliveryDetails.remove(key);
        if (deliveryDetails.length == 0) {
          done();
        }
      });
    });
  }

  static void getLogin(void done(String username)) async {
    prefs = await SharedPreferences.getInstance();
    String username = await prefs.get('username');
    done(username);
  }
  static void getToken(void done(String token)) async {
    prefs = await SharedPreferences.getInstance();
    String token = await prefs.get('fcmtoken');
    done(token);
  }
  static void saveLogin(String username) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }
  static void saveToken(String username) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmtoken', username);
  }
  static void deleteLogin() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
  }
}