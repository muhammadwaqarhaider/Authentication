// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Contacts Saver',
// //       theme: ThemeData(primarySwatch: Colors.blue),
// //       home: ContactsScreen(),
// //     );
// //   }
// // }
//
// class ContactsScreen extends StatefulWidget {
//   @override
//   _ContactsScreenState createState() => _ContactsScreenState();
// }
//
// class _ContactsScreenState extends State<ContactsScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contacts Saver'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('contacts').snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }
//
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 return ListView(
//                   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                     return ListTile(
//                       title: Text(document['name']),
//                       subtitle: Text(document['phone']),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => _deleteContact(document.id),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(hintText: 'Name'),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(hintText: 'Phone'),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   child: Text('Save Contact'),
//                   onPressed: _saveContact,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _saveContact() async {
//     String name = _nameController.text.trim();
//     String phone = _phoneController.text.trim();
//
//     if (name.isEmpty || phone.isEmpty) {
//       return;
//     }
//
//     await _firestore.collection('contacts').add({
//       'name': name,
//       'phone': phone,
//     });
//
//     _nameController.clear();
//     _phoneController.clear();
//   }
//
//   void _deleteContact(String id) async {
//     await _firestore.collection('contacts').doc(id).delete();
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text("Contacts saver",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('contacts').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final contacts = snapshot.data!.docs
                      .where((doc) =>
                  doc['name']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                      doc['phone']
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return ListView(
                    children: contacts.map((DocumentSnapshot document) {
                      return ListTile(
                        title: Text(document['name']),
                        subtitle: Text(document['phone']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,color: Colors.grey,),
                          onPressed: () => _deleteContact(document.id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          label: Text("Name",style: TextStyle(color: Colors.grey),),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          label: Text("Phone",style: TextStyle(color: Colors.grey),),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Save Contact'),
                    onPressed: _saveContact,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _saveContact() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      return;
    }

    await _firestore.collection('contacts').add({
      'name': name,
      'phone': phone,
    });

    _nameController.clear();
    _phoneController.clear();
  }

  void _deleteContact(String id) async {
    await _firestore.collection('contacts').doc(id).delete();
  }
}
