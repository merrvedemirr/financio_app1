import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio_app/views/Login/person_profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String verificationId;
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;

  VerifyPhoneScreen({
    required this.verificationId,
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
  });

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _smsCode;

  void _verifyPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCode!,
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Kullanıcı bilgilerini Firestore'a kaydedin
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': widget.name,
          'surname': widget.surname,
          'email': widget.email,
          'phoneNumber': widget.phoneNumber,
        });

        // Profil sayfasına yönlendirin
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doğrulama başarısız: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telefon Numarasını Doğrula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'SMS Kodu'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'SMS kodu boş olamaz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _smsCode = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                child: Text('Doğrula'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
