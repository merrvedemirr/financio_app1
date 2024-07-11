import 'package:financio_app/widgets/loading_circle.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/constants/parameters.dart';

class Stock {
  final rate;
  final lastPrice;
  final String lastPriceStr;
  final volume;
  final String volumeStr;
  final String text;
  final String code;

  Stock({
    required this.rate,
    required this.lastPrice,
    required this.lastPriceStr,
    required this.volume,
    required this.volumeStr,
    required this.text,
    required this.code,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      rate: json['rate'],
      lastPrice: json['lastprice'],
      lastPriceStr: json['lastpricestr'],
      volume: json['hacim'],
      volumeStr: json['hacimstr'],
      text: json['text'],
      code: json['code'],
    );
  }
}

Future<List<Stock>> fetchStocks() async {
  final response = await http.get(
    Uri.parse('https://api.collectapi.com/economy/hisseSenedi'),
    headers: {
      'authorization': 'apikey 1GPOH7otXD1PjUUIM5B7mr:7lQS9zKSiZc4P2sGsQwzaO',
      'content-type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> results = data['result'];
    print(results);
    return results.map((json) => Stock.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load stocks');
  }
}

class StockListScreen extends StatefulWidget {
  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  late Future<List<Stock>> futureStocks;
  List<Stock> _stocks = [];
  List<Stock> _filteredStocks = [];

  @override
  void initState() {
    super.initState();
    futureStocks = fetchStocks().then((stocks) {
      _stocks = stocks;
      _filteredStocks = stocks;
      return stocks;
    });
  }

  void _filterStocks(String query) {
    final filteredStocks = _stocks.where((stock) {
      final stockTextLower = stock.text.toLowerCase();
      final stockCodeLower = stock.code.toLowerCase();
      final queryLower = query.toLowerCase();

      return stockTextLower.contains(queryLower) || stockCodeLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredStocks = filteredStocks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Stock>>(
        future: futureStocks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading_circle();
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Veri bulunamadı'));
          } else {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    onChanged: _filterStocks,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ara",
                        suffixIcon: Icon(
                          Icons.search,
                          color: maincolor,
                        )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredStocks.length,
                    itemBuilder: (context, index) {
                      final stock = _filteredStocks[index];
                      return StockCard(stock: stock);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  final Stock stock;

  const StockCard({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: CircleAvatar(
          backgroundColor: stock.rate > 0 ? Colors.green : Colors.red,
          child: Text(
            stock.rate.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          stock.text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Kod: ${stock.code}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Son Fiyat: ${stock.lastPriceStr}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Hacim: ${stock.volumeStr}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
