import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../drawers/drawers.dart';
import '../model/user_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Stream<QuerySnapshot> sales =
      FirebaseFirestore.instance.collection('sales').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelles ventes"),
        centerTitle: true,
      ),
      drawer: const DrawerScreen(),
      body: StreamBuilder<QuerySnapshot>(
        stream: sales,
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
                                        Icons.notification_important,
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
                                          '${data.docs[index]['libelle']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Montant : ${data.docs[index]['montant']} €',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          'Statut : ${data.docs[index]['statut']}€',
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
              ],
            ),
          );
        },
      ),
    );
  }
}
