import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/constants/parameters.dart';
import '/main.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  String firstName = '-';
  String lastName = '-';
  String? phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get()
        .asStream()
        .listen((event) {
      setState(() {
        firstName = event["firstName"];
        lastName = event["lastName"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: maincolor,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              phoneNumber!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('İsim'),
                    subtitle: Text(firstName),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Soyisim'),
                    subtitle: Text(lastName),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Telefon Numarası'),
                    subtitle: Text(phoneNumber!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Çıkış yapma işlemleri burada yapılır
                //print('Çıkış yap butonuna basıldı');

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: maincolor,
                        size: 50.0,
                      ),
                    );
                  },
                );
                try {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                  });
                } catch (e) {
                  print(e);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
