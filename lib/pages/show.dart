import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Front extends StatefulWidget {
  const Front({super.key});

  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut(); // Pop all routes until home screen
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

// Function to clear the entire cache
  void clearCache() async {
    DefaultCacheManager().emptyCache();
  }

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('user');
  final snapshot = FirebaseFirestore.instance.collection('user').snapshots();
  String capitalize(String text) {
    if (text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> _deleteDocument(String documentId) async {
    await _user
        .doc(documentId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
    // Perform any additional actions or show a success message if neededvs
  }

  void _confirmDeleteDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this document?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteDocument(documentId);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();

      // Navigate back to the login page
      //next
      clearCache();
      context.go('/signin');
    } catch (e) {
      // Handle logout errors
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // This pops the current route and goes back
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                // Code for the first button action goes here
                context.go('/registration');
              },
              child: const Text(
                'ADD',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white10,
        child: StreamBuilder<QuerySnapshot>(
            stream: _user.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No data found.'),
                );
              }

              return Container(
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Container(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalize(data['name']),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Text(data['phone'].toString()),
                              ]),
                        ),
                        trailing: SizedBox(
                          width: 98,
                          //hello
                          child: Row(children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                context.go('/edit/${document.id}');
                              },
                            ),
                            // InkWell(
                            //     onPressed: (() {
                            //       context.go('/edit/${document.id}');
                            //
                            //     }),
                            //     child: Icon(Icons.edit)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _confirmDeleteDialog(document.id);
                              },
                            ),
                          ]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                //ekkada?
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code for the FAB action goes here
          // Replace '/your_route_here' with the route you want to navigate to
          //context.go('/signin');
          _logout();
        },
        child: Icon(Icons.logout_sharp),
        backgroundColor: Colors.grey[800], // Customize the FAB background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
