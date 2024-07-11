import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio_app/views/Login/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final userDocument = FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    return FutureBuilder<DocumentSnapshot>(
      future: userDocument,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text('${userData['firstName']} ${userData['lastName']}'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
            body: Center(
              child: Text('Welcome, ${userData['firstName']} ${userData['lastName']}'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(child: Text('Failed to load user data')),
          );
        }
      },
    );
  }
}
