import 'package:flutter/material.dart';
import 'news.dart';
import 'add.dart';
import 'search.dart';
import 'news_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    setState(() {
      _loading = true;
      _error = false;
    });
    updateNews((success) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = !success;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Search())
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _fetchNews,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.blue, size: 28),
            onPressed: () {
               Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Add())
              ).then((_) => _fetchNews());
            },
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load news'),
                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: _fetchNews, child: const Text('Retry'))
                    ],
                  ),
                )
              : NewsList(),
    );
  }
}

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty) {
      return const Center(child: Text('No news available'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return NewsCard(news: newsList[index]);
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NewsDetail(news: news))
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 20),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (news.imageUrl.isNotEmpty)
                  Image.network(
                    news.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 220, 
                      color: Colors.grey[200], 
                      child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey))
                    ),
                  )
                else
                  Container(
                    height: 180,
                    color: Colors.blueGrey[100],
                    child: const Center(child: Icon(Icons.article, size: 64, color: Colors.blueGrey)),
                  ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      news.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    news.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], height: 1.4),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        news.date,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      Text(
                        "READ MORE →",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

