import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    await Provider.of<AuthService>(context, listen: false).getUser.then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home_screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlutterLogo(size: 150),
              Text(
                'Login to start the quiz',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              LoginButton(
                text: 'LOGIN WITH GOOGLE',
                icon: FontAwesomeIcons.google,
                color: Colors.black45,
                loginMethod: Provider.of<AuthService>(context, listen: false)
                    .googleSignIn,
              ),
              LoginButton(
                text: 'Continue as Guest',
                icon: FontAwesomeIcons.solidUserCircle,
                loginMethod:
                    Provider.of<AuthService>(context, listen: false).anonSignIn,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/home_screen');
          }
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
        color: color,
      ),
    );
  }
}
