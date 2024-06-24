import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

}
