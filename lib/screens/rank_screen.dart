import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../drawers/drawers.dart';
import '../model/user_model.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({Key? key}) : super(key: key);

  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection('users')
      .orderBy("CA", descending: true)
      .limit(5)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classement"),
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

          return Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: index == 4
                                ? const EdgeInsets.fromLTRB(0, 0, 100, 0)
                                : index == 3
                                    ? const EdgeInsets.fromLTRB(0, 0, 75, 0)
                                    : index == 2
                                        ? const EdgeInsets.fromLTRB(0, 0, 50, 0)
                                        : index == 1
                                            ? const EdgeInsets.fromLTRB(
                                                0, 0, 25, 0)
                                            : const EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                color: index == 4
                                    ? Colors.orange.shade100
                                    : index == 3
                                        ? Colors.orange.shade200
                                        : index == 2
                                            ? Colors.orange.shade300
                                            : index == 1
                                                ? Colors.orange.shade400
                                                : Colors.orange.shade500,
                                child: Row(
                                  children: [
                                    Container(
                                      color: index == 4
                                          ? Colors.orange.shade900
                                          : index == 3
                                              ? Colors.orange.shade900
                                              : index == 2
                                                  ? Colors.orange.shade900
                                                  : index == 1
                                                      ? Colors.orange.shade900
                                                      : Colors.orange.shade900,
                                      width: 70,
                                      height: 70,
                                      child: Center(
                                          child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                            color: Colors.white),
                                      )),
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
                                          '${data.docs[index]['firstName']} ${data.docs[index]['secondName']} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
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
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      );
                    },
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
