import 'package:financio_app/views/Login/authcheck.dart';
import 'package:flutter/material.dart';
import '/views/exchange.dart';
import '/constants/parameters.dart';
import 'News/news.dart';
//import '/views/profile.dart';
import '/views/turks_exchange.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    StockMarketPage(),
    StockListScreen(),
    const NewsPage(),
    const Authcheck(),
  ];
  int pagenum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(width: 170, child: Image.asset("assets/logo.png")),
        centerTitle: true,
      ),
      body: pages[pagenum],
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

//Menü Çubuğu
  Container _bottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: maincolor, blurRadius: 20)], borderRadius: BorderRadius.circular(30)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.currency_exchange_rounded), label: "Canlı Borsa"),
            BottomNavigationBarItem(icon: Icon(Icons.currency_exchange), label: "Türk Borsaları"),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "Haberler"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
          selectedItemColor: maincolor,
          currentIndex: pagenum,
          onTap: (value) {
            setState(() {
              pagenum = value;
            });
          },
        ),
      ),
    );
  }
}
