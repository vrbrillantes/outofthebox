import 'package:flutter/material.dart';
import 'dialog.generic.dart';
import 'screen.login.dart';
import 'screen.ordersproductscarts.dart';
import 'util.login.dart';
class ScreenHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScreenHomeState();
  }
}

class ScreenHomeState extends StatefulWidget {
  @override
  _ScreenHomeBuild createState() => new _ScreenHomeBuild();
}

class _ScreenHomeBuild extends State<ScreenHomeState> with SingleTickerProviderStateMixin {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  void loggedIn(bool li) {
    setState(() {
      isLoggedIn = li;
    });
  }

  void logOut() {
    GenericDialogGenerator.logOut(context, () {
      LoginFunctions.logOut();
      setState(() {
        isLoggedIn = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: isLoggedIn ? new ScreenOrdersProductsCarts(onLogOut: logOut) : new ScreenLogin(onLogIn: loggedIn));
  }
}
