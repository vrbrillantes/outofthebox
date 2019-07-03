import 'dart:async';
import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';
import 'util.preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class LoginPreferences {
  static void getLogin(void done(String username)) {
    AppPreferences.getLogin(done);
  }

  static void getToken(void done(String token)) {
    AppPreferences.getToken(done);
  }

  static void saveLogin(String username) {
    AppPreferences.saveLogin(username);
  }

  static void saveFCM(String token) {
    AppPreferences.saveToken(token);
  }

  static void deleteLogin() {
    AppPreferences.deleteLogin();
  }
}

class LoginFunctions {
  static GoogleSignInAccount _currentUser;

  static Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  static void getUserName(void done(String u)) {
    LoginPreferences.getLogin((String userEmail) async {
//      _userEmail = userEmail;
//      _username = _userEmail.replaceAll("@globe.com.ph", "");
      done(userEmail.replaceAll("@globe.com.ph", ""));
    });
  }

  static void initSignIn(void loggedIn(bool li), void done()) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      if (_currentUser != null) {
        loggedIn(saveLogin());
//        _handleGetContact();
        setupFCM();
      }
    });
    _googleSignIn.signInSilently().then((GoogleSignInAccount acc) {
      done();
    });
  }

  static bool saveLogin() {
    if (_currentUser.email.endsWith("@globe.com.ph")) {
      LoginPreferences.saveLogin(_currentUser.email);
      return true;
    } else {
      return false;
    }
  }

  static void logOut() {
//    _auth.signOut();
    _googleSignIn.signOut();
    LoginPreferences.deleteLogin();
  }

  static void setupFCM() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );
    LoginPreferences.getToken((String token) {
      if (token == null)
        _firebaseMessaging.getToken().then((String newToken) {
          assert(newToken != null);
          LoginPreferences.saveFCM(newToken);
        });
    });
  }

  static void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }
  static void testLogin() {
    LoginPreferences.getLogin((String userEmail) async {
//      if (userEmail == null) {
      _handleSignIn();
//        loggedIn(false);
//      } else {
//        _userEmail = userEmail;
//        loggedIn(true);
//      }
    });
  }
}
