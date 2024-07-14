import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String country;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Employee(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      country: data['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
    };
  }
}
