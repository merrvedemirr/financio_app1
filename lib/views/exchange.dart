import 'package:financio_app/Model/stockdata_model.dart';
import 'package:financio_app/widgets/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/constants/parameters.dart';
import '/views/exchange_graph.dart';

class StockMarketPage extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Stock(), //veriler geliyor.
      ),
      GoRoute(
        path: '/graph',
        builder: (context, state) => const Exchange_Graph_Screen(), //grafik ekranı
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routerConfig: _router,
    );
  }
}

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  var stocks; // Hisse senedi verilerini tutacak liste

  String chipCode = "allCurrency"; //tüm veriler

  @override
  void initState() {
    super.initState();
    fetchData(chipCode); // Verileri yükleme işlemi
  }

//todo: verileri çekiyoruz.
  Future<void> fetchData(String type) async {
    setState(() {
      stocks = null;
    });
    var url = Uri.parse('https://api.collectapi.com/economy/$type');
    var headers = {
      'authorization': collectAPI_KEY,
      'content-type': 'application/json',
    };
    // Verileri API'den çekme işlemi (örneğin)
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      //döviz kuru
      if (type == "silverPrice") {
        setState(() {
          stocks = jsonDecode(response.body)["result"];
          print(stocks);
        });
      }
      //kripto
      if (type == "cripto") {
        setState(() {
          stocks = jsonDecode(response.body)["result"];
          print(stocks);
        });
      }
      //altın kuru - gümüş kuru
      if (type == "allCurrency" || type == "goldPrice") {
        setState(() {
          stocks = (jsonDecode(response.body)["result"] as List).map((data) => StockData.fromJson(data)).toList();
        });
      }

      setState(() {});
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  List chipData = [
    {"name": "Döviz Kuru", "code": "allCurrency"},
    {"name": "Kripto", "code": "cripto"},
    {"name": "Altın Kuru", "code": "goldPrice"},
    {"name": "Gümüş Kuru", "code": "silverPrice"},
  ];

  TextEditingController search_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chipData.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      //*üstteki tıklanan menüye göre veriler geliyor.
                      if (chipData[i]["code"] != chipCode) {
                        setState(() {
                          chipCode = chipData[i]["code"];
                          fetchData(chipCode);
                        });
                      }
                    },
                    child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          //*Seçilen menünün bg değiştirme
                          borderRadius: BorderRadius.circular(20),
                          color: chipData[i]["code"] == chipCode ? maincolor : Colors.grey.shade800,
                        ),
                        child: Center(
                            child: Text(
                          chipData[i]["name"],
                          style: const TextStyle(color: Colors.white),
                        ))),
                  );
                }),
          ),
          if (chipCode == "cripto")
            Expanded(
                child: stocks == null
                    ? const Loading_circle()
                    : Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              controller: search_Controller,
                              onChanged: (value) {
                                print(search_Controller.text);
                                setState(() {
                                  search_Controller;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ara",
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: stocks.length,
                              itemBuilder: (context, index) {
                                if (search_Controller.text.isEmpty) {
                                  return StockCard(
                                      stock: StockData(
                                          name: stocks[index]["name"],
                                          buyPrice: stocks[index]["price"],
                                          sellPrice: stocks[index]["price"],
                                          rate: double.parse(stocks[index]["changeDaystr"])));
                                } else if (stocks[index]["name"]
                                    .toLowerCase()
                                    .contains(search_Controller.text.toLowerCase())) {
                                  return StockCard(
                                      stock: StockData(
                                          name: stocks[index]["name"],
                                          buyPrice: stocks[index]["price"],
                                          sellPrice: stocks[index]["price"],
                                          rate: double.parse(stocks[index]["changeDaystr"])));
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                        ],
                      )),
          if (chipCode == "silverPrice")
            Expanded(
                child: stocks == null
                    ? const Loading_circle()
                    : ListView(
                        children: [
                          StockCard(
                              stock: StockData(
                                  name: "Gümüş", buyPrice: stocks["buying"], sellPrice: stocks["selling"], rate: 1))
                        ],
                      )),
          if (chipCode == "allCurrency" || chipCode == "goldPrice")
            Expanded(
              child: stocks == null
                  ? const Loading_circle()
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          decoration:
                              BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            controller: search_Controller,
                            onChanged: (value) {
                              print(search_Controller.text);
                              setState(() {
                                search_Controller;
                              });
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ara",
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: stocks.length,
                            itemBuilder: (context, index) {
                              if (search_Controller.text.isEmpty) {
                                return StockCard(stock: stocks[index]);
                              } else if (stocks[index]
                                  .name
                                  .toLowerCase()
                                  .contains(search_Controller.text.toLowerCase())) {
                                return StockCard(stock: stocks[index]);
                              } else {
                                return const SizedBox();
                              }
                            },
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

class StockCard extends StatelessWidget {
  final StockData stock;

  const StockCard({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color changeColor = stock.rate >= 0 ? Colors.green : Colors.red;
    Icon changeIcon = stock.rate >= 0
        ? const Icon(
            Icons.arrow_upward,
            color: Colors.green,
          )
        : const Icon(
            Icons.arrow_downward,
            color: Colors.red,
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // context.go('/graph');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Alış: ${stock.buyPrice.toStringAsFixed(2)} TL',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Satış: ${stock.sellPrice.toStringAsFixed(2)} TL',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    changeIcon,
                    const SizedBox(height: 4.0),
                    Text(
                      '${stock.rate.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: changeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
