import 'package:flutter/material.dart';
import 'ui.util.dart';
import 'util.login.dart';
import 'dialog.generic.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({this.onLogIn});

  final void Function(bool) onLogIn;

  @override
  Widget build(BuildContext context) {
    return new ScreenLoginState(onLogIn: onLogIn);
  }
}

class ScreenLoginState extends StatefulWidget {
  ScreenLoginState({this.onLogIn});

  final void Function(bool) onLogIn;

  @override
  _ScreenLoginBuild createState() => new _ScreenLoginBuild(onLogIn: onLogIn);
}

class _ScreenLoginBuild extends State<ScreenLoginState> {
  _ScreenLoginBuild({this.onLogIn});

  bool returnedLogin = false;
  bool validLogin = true;
  final void Function(bool) onLogIn;

  @override
  void initState() {
    super.initState();
    LoginFunctions.initSignIn((bool b) async {
      setState(() {
        validLogin = b;
        onLogIn(b);
        returnedLogin = true;
      });
    }, () {
      setState(() {
        returnedLogin = true;
      });
    });
  }

  void login() {
    LoginFunctions.testLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.lightBlue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('images/welcomelogo.png', height: 250.0),
            Column(
              children: <Widget>[
                RaisedButton(
                  elevation: 0.0,
                  color: Colors.white,
                  child: Text('Login', style: AppTextStyles.titleStyle),
                  onPressed: returnedLogin ? login : null,
                ),
                validLogin
                    ? SizedBox()
                    : Text(
                        "Please login using your Globe GMail account",
                        style: AppTextStyles.labelWhiteMini,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
