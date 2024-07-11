import 'package:financio_app/views/Login/is_login.dart';
import 'package:financio_app/widgets/loading_circle.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

class Authcheck extends StatelessWidget {
  const Authcheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loading_circle());
        } else if (snapshot.hasData) {
          //*eğer kayıt olmuşsa buraya ayarlar ekranı
          return const IsLogin();
        } else {
          //*eğer kayıt olmamışsa veya giriş yapmamışsa
          return const IsLogin();
        }
      },
    );
  }
}
