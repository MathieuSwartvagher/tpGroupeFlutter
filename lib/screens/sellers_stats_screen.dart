import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../drawers/drawers.dart';
import '../model/user_model.dart';

class SellersStatScreen extends StatefulWidget {
  const SellersStatScreen({Key? key}) : super(key: key);

  @override
  _SellersStatScreenState createState() => _SellersStatScreenState();
}

class _SellersStatScreenState extends State<SellersStatScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  int caTotal = 0;

  final Stream<QuerySnapshot> chiffreAffaire =
      FirebaseFirestore.instance.collection('users').snapshots();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
        centerTitle: true,
      ),
      drawer: const DrawerScreen(),
      body: StreamBuilder<QuerySnapshot>(
        stream: users,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text('Error with data read');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          final data = snapshot.requireData;
          caTotal = 0;
          for (int i = 0; i < data.size; i++) {
            int a = data.docs[i]['CA'];
            caTotal = caTotal + a;
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                color: Colors.grey.shade100,
                                child: Row(
                                  children: [
                                    Container(
                                      color: index % 2 == 0
                                          ? const Color.fromARGB(
                                              193, 201, 31, 31)
                                          : const Color.fromARGB(
                                              186, 228, 20, 20),
                                      width: 70,
                                      height: 70,
                                      child: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data.docs[index]['firstName']} ${data.docs[index]['secondName']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Nombre de ventes : ${data.docs[index]['nbVente']}',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          'Chiffre d\'affaire : ${data.docs[index]['CA']}€',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (loggedInUser.role == "Admin")
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Chiffre d'affaires total : $caTotal €",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
