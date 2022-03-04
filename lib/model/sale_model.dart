class SaleModel {
  String? uidUser;
  String? libelle;
  String? montant;
  String? statut;
  String? numFac;

  SaleModel({
    this.uidUser,
    this.libelle,
    this.montant,
    this.statut,
    this.numFac,
  });

  // receiving data from server
  factory SaleModel.fromMap(map) {
    return SaleModel(
      uidUser: map['uidUser'],
      libelle: map['libelle'],
      montant: map['montant'],
      statut: map['statut'],
      numFac: map['numFac'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uidUser': uidUser,
      'libelle': libelle,
      'montant': montant,
      'statut': statut,
      'numFac': numFac,
    };
  }
}
