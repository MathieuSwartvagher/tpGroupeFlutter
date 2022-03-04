class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? role;
  String? nbVente;
  int? CA;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.role,
      this.nbVente,
      this.CA});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      role: map['role'],
      nbVente: map['nbVente'],
      CA: map['CA'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'role': role,
      'nbVente': nbVente,
      'CA': CA,
    };
  }
}
