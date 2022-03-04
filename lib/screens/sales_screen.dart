import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tp_goupe/model/sale_model.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../drawers/drawers.dart';
import '../model/user_model.dart';
import 'package:uuid/uuid.dart';

import 'edit_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late Stream<QuerySnapshot> sales;

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

    sales = FirebaseFirestore.instance
        .collection('sales')
        .where("uidUser", isEqualTo: user!.uid)
        .snapshots();
  }

  // string for displaying the error Message
  String? errorMessage;
  String selectedValue = "Visite technique validée";
  // editing Controller
  final nomObjetEditingController = TextEditingController();
  final montantEditingController = TextEditingController();
  final statutEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nomObjetField = TextFormField(
        autofocus: false,
        controller: nomObjetEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Libelle cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          nomObjetEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.receipt),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Libelle",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final montantField = TextFormField(
        autofocus: false,
        controller: montantEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Amount cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          montantEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.monetization_on),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Amount",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //statut field
    final statutField = Container(
      padding: const EdgeInsets.all(1),
      child: DropDownFormField(
        titleText: 'Statut',
        hintText: 'Please choose one',
        value: selectedValue,
        onSaved: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        dataSource: const [
          {
            "display": "Visite technique validée",
            "value": "Visite technique validée",
          },
          {
            "display": "Vendu",
            "value": "Vendu",
          },
          {
            "display": "Financement validé",
            "value": "Financement validé",
          },
          {
            "display": "Annulation",
            "value": "Annulation",
          }
        ],
        textField: 'display',
        valueField: 'value',
      ),
    );

    //createSale button
    final createSaleButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          createSale();
        },
        child: const Text(
          "Créer une vente",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stats"),
        centerTitle: true,
      ),
      drawer: const DrawerScreen(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 45),
                    nomObjetField,
                    const SizedBox(height: 20),
                    montantField,
                    const SizedBox(height: 20),
                    statutField,
                    const SizedBox(height: 20),
                    /*  DropdownButton(
                      value: selectedValue,
                      items: <String>[
                        'Visite technique validée',
                        'Vendu',
                        'Financement validé',
                        'Annulation'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ), */
                    createSaleButton,
                    const SizedBox(height: 25),
                    StreamBuilder<QuerySnapshot>(
                      stream: sales,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return const Text('Error with data read');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading');
                        }

                        final data = snapshot.requireData;

                        return Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          height: MediaQuery.of(context).size.height * 0.6,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                    child: GestureDetector(
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 22,
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => EditScreen(
                                                                data.docs[index]
                                                                    ['libelle'],
                                                                data.docs[index]
                                                                    ['montant'],
                                                                data.docs[index]
                                                                    ['statut'],
                                                                data.docs[index]
                                                                    [
                                                                    'numFac'])));
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${data.docs[index]['libelle']}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${data.docs[index]['montant']} €',
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                      Text(
                                                        'Statut : ${data.docs[index]['statut']}',
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createSale() async {
    if (_formKey.currentState!.validate()) {
      postDetailsToFirestore();
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    SaleModel saleModel = SaleModel();

    var uuid = Uuid();

    // writing all the values
    saleModel.numFac = uuid.v1();
    saleModel.uidUser = user!.uid;
    saleModel.libelle = nomObjetEditingController.text;
    saleModel.montant = montantEditingController.text;
    saleModel.statut = selectedValue;

    await firebaseFirestore
        .collection("sales")
        .doc(saleModel.numFac)
        .set(saleModel.toMap());
    Fluttertoast.showToast(msg: "Sale created successfully :) ");

    int oldCA = loggedInUser.CA!;
    int oldNbVente = int.parse(loggedInUser.nbVente!);

    int newCA = oldCA + int.parse(montantEditingController.text);
    int newNbVente = oldNbVente + 1;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update({"nbVente": newNbVente.toString(), "CA": newCA});

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const SalesScreen()),
        (route) => false);
  }
}
