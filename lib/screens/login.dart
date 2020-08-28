import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              SizedBox(height: 50),
              FlutterLogo(size: 150),
              Text(
                'Login to start the quiz',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              Text(
                  'Test your app development knowledge with quick bite-sized quizzes.'),
              SizedBox(height: 150),
              LoginButton(
                text: 'Sign in with Google',
                icon: FontAwesomeIcons.google,
                color: Colors.black45,
                loginMethod: Provider.of<AuthService>(context, listen: false)
                    .googleSignIn,
              ),
              FutureBuilder<Object>(
                future: Provider.of<AuthService>(context, listen: false)
                    .appleSignInAvailable,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 38),
                      child: AppleSignInButton(
                        onPressed: () async {
                          User user = await Provider.of<AuthService>(context,
                                  listen: false)
                              .anonSignIn();
                          if (user != null) {
                            Navigator.pushReplacementNamed(
                                context, '/home_screen');
                          }
                        },
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
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
      child: ButtonTheme(
        minWidth: 260,
        height: 60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: FlatButton.icon(
          onPressed: () async {
            User user = await loginMethod();
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/home_screen');
            }
          },
          icon: Icon(icon, color: Colors.white),
          label: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          color: color,
        ),
      ),
    );
  }
}
