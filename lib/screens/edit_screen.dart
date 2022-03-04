import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tp_goupe/model/sale_model.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:tp_goupe/screens/sales_screen.dart';

import '../drawers/drawers.dart';
import '../model/user_model.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  String libelle;
  String montant;
  String statut;
  String numFac;

  // ignore: use_key_in_widget_constructors
  EditScreen(this.libelle, this.montant, this.statut, this.numFac);

  @override
  _EditScreenState createState() =>
      // ignore: no_logic_in_create_state
      _EditScreenState(libelle, montant, statut, numFac);
}

class _EditScreenState extends State<EditScreen> {
  late String libelle;
  late String montant;
  late String statut;
  late String selectedValue;
  late String numFac;

  late int startCA;
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late Stream<QuerySnapshot> sales;

  _EditScreenState(this.libelle, this.montant, this.statut, this.numFac);

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

    nomObjetEditingController.text = libelle;
    montantEditingController.text = montant;
    selectedValue = statut;
    startCA = int.parse(montant);
  }

  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final nomObjetEditingController = TextEditingController();
  final montantEditingController = TextEditingController();

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
          updateSale();
        },
        child: const Text(
          "Editer une vente",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit sale'),
      ),
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
                    createSaleButton,
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateSale() async {
    if (_formKey.currentState!.validate()) {
      updateDetailsToFirestore();
    }
  }

  updateDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    int oldCA = loggedInUser.CA!;

    int newCA = (oldCA - startCA) + int.parse(montantEditingController.text);

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update({"CA": newCA});

    await firebaseFirestore.collection("sales").doc(numFac).update({
      "statut": selectedValue,
      "montant": montantEditingController.text,
      "libelle": nomObjetEditingController.text
    });
    Fluttertoast.showToast(msg: "Sale edited successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const SalesScreen()),
        (route) => false);
  }
}
