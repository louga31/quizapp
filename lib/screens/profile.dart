import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Container(
      child: Center(
        child: FlatButton(
          onPressed: () async {
            await Provider.of<AuthService>(context, listen: false).signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          child: Text('Log Out'),
          color: Colors.red,
        ),
      ),
    );
  }
}
