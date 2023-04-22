import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String uid;
  final String email;
  final int age;
  final String vehicleNo;

  User({
    required this.email,
    required this.uid,
    required this.age,
    required this.name,
    required this.vehicleNo
  });

  Map<String, dynamic> toJson() =>
      {'username': name, 'uid': uid, 'email': email, 'age': age,'vehicleNo':vehicleNo};

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      age: snapshot['age'],
      vehicleNo: snapshot['vehicleNo']
    );
  }
}