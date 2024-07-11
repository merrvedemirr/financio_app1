import 'dart:convert';
import 'dart:io';
import 'package:financio_app/constants/parameters.dart';
import 'package:http/http.dart' as http;

class NewsModel {
  final String imageUrl;
  final String name;
  final String description;
  final String date;

  NewsModel({required this.imageUrl, required this.name, required this.description, required this.date});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      imageUrl: json['image'],
      name: json['name'],
      description: json['description'],
      date: json["date"],
    );
  }
}

Future<Map<String, dynamic>> fetchNews() async {
  try {
    var url = Uri.parse('https://api.collectapi.com/news/getNews?country=tr&tag=economy');
    var headers = {
      'authorization': collectAPI_KEY,
      'content-type': 'application/json',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load news');
    }
  } on SocketException {
    throw Exception('No Internet connection');
  } on HttpException {
    throw Exception('Could not find the post');
  } on FormatException {
    throw Exception('Bad response format');
  } catch (e) {
    throw Exception('Unknown error: $e');
  }
}

String formatDate(String dateString) {
  // API'den gelen tarih bilgisini DateTime objesine çevirin
  DateTime parsedDate = DateTime.parse(dateString);

  // İstediğiniz formatta tarih ve saat stringi oluşturun
  String formattedDate =
      "${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";

  return formattedDate;
}
