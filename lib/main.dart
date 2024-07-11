import 'dart:async';
import 'package:financio_app/widgets/circular_particle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = const FirebaseOptions(
    apiKey: "AIzaSyCMWRMnUcH44u-OOxH59rXczjOD5iJjbUI",
    authDomain: "financioo.firebaseapp.com",
    databaseURL: "https://financioo.firebaseio.com",
    projectId: "financioo",
    storageBucket: "financioo.appspot.com",
    messagingSenderId: "793357497701",
    appId: "1:793357497701:android:e1b575daae49909a255d8c",
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SplashScreen(), //SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // checker() async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
  //         .get();
  //     Timer(
  //         const Duration(seconds: 3),
  //         () => Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => FirebaseAuth.instance.currentUser == null
  //                   ? PhoneAuthScreen()
  //                   : documentSnapshot.exists
  //                       ? MainPage()
  //                       : PhoneAuthScreen(),
  //             ),
  //             (route) => false));
  //   } else {
  //     Timer(
  //         const Duration(seconds: 3),
  //         () => Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => PhoneAuthScreen(),
  //             ),
  //             (route) => false));
  //   }
  // }

  void navigate() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
            (route) => false));
  }

//İnternet Kontrolü
  // Future<void> _checkInternetConnection() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
  //     // İnternet bağlantısı var, diğer sayfaya yönlendirin
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => MainPage()),
  //     );
  //   } else {
  //     // İnternet bağlantısı yok, uyarı göster
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Bağlantınız Yok!"),
  //           content: Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz."),
  //           actions: [
  //             TextButton(
  //               child: Text("Tekrar Dene"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 _checkInternetConnection();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // SplashScreen 3 saniye gösterdikten sonra başka sayfaya geçiş yapacak
    //checker();
    navigate();
    //_checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const Circular_Particle(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(flex: 5, child: Container(width: 300, child: Image.asset("assets/logo.png"))),
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Senin yerine ama senin kontrolünde',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: const Text("Financio Yazılım ve Bilişim LTD. ŞTİ."),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
