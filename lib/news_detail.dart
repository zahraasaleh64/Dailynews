import 'package:flutter/material.dart';
import 'news.dart';

class NewsDetail extends StatelessWidget {
  final News news;

  const NewsDetail({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl.isNotEmpty)
              Image.network(
                news.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey))
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.blueGrey[50],
                child: const Center(child: Icon(Icons.article, size: 100, color: Colors.blueGrey)),
              ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      news.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    news.date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const Divider(height: 40),
                  Text(
                    news.content,
                    style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.6),
                  ),
                  const SizedBox(height: 100), // Space at bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
