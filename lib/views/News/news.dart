import 'package:financio_app/views/News/news_detail.dart';
import 'package:financio_app/views/News/news_model.dart';
import 'package:financio_app/widgets/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<Map<String, dynamic>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading_circle();
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!['result'] == null) {
              return const Text('Veri bulunamadı');
            } else {
              List<dynamic> articles = snapshot.data!['result'];
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                      items: articles.map((article) {
                        NewsModel news = NewsModel.fromJson(article);
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              child: supNews(news: news),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewsDetail(news: news),
                                ));
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 3,
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        NewsModel news = NewsModel.fromJson(articles[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsDetail(news: news),
                            ));
                          },
                          child: subNews(news: news),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class supNews extends StatelessWidget {
  //todo: Üstteki Hbaer Kısmı
  const supNews({
    super.key,
    required this.news,
  });

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Stack(
        children: [
          Image.network(news.imageUrl, fit: BoxFit.fitHeight, width: double.infinity),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                news.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class subNews extends StatelessWidget {
  //todo: Alttaki HAber KIsmı
  const subNews({
    super.key,
    required this.news,
  });

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                news.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              subtitle: Text("Gündem: ${formatDate(news.date)}"),
              leading: Image.network(news.imageUrl),
            ),
          ),
        ),
      ],
    );
  }
}
