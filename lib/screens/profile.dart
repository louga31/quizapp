import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/models/models.dart';
import 'package:quizapp/services/services.dart';
import 'package:quizapp/shared/shared.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    User user = Provider.of<User>(context);
    if (user != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (user.photoURL != null)
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photoURL),
                  ),
                ),
              ),
            Text(user.email ?? '',
                style: Theme.of(context).textTheme.headline5),
            Spacer(),
            if (report != null)
              Text('${report.total ?? 0}',
                  style: Theme.of(context).textTheme.headline2),
            Text('Quizzes Completed',
                style: Theme.of(context).textTheme.subtitle1),
            Spacer(),
            FlatButton(
                child: Text('logout'),
                color: Colors.red,
                onPressed: () async {
                  await Provider.of<AuthService>(context, listen: false)
                      .signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }),
            Spacer()
          ],
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
