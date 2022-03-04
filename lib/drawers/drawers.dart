// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_goupe/screens/notification_screen.dart';
import 'package:tp_goupe/screens/rank_screen.dart';
import 'package:tp_goupe/screens/sales_screen.dart';

import '../model/user_model.dart';
import '../screens/login_screen.dart';
import '../screens/sellers_stats_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(
                        "${loggedInUser.firstName} ${loggedInUser.secondName}",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.person,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      onTap: () {
                        /* Navigator.pop(context);
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => dealerBuilder()));*/
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Notification',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.shuffle,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Sales',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.info_outline,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SalesScreen()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Sales performance',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.border_color,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SellersStatScreen()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Rank',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.border_color,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RankScreen()));
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  Divider(),
                  Container(
                    color: Colors.red,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      onTap: () {
                        logout(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
