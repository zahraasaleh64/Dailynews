import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const String baseURL = 'fatimamobile.atwebpages.com';

class News {
  int nid;
  String title;
  String content;
  String imageUrl;
  String date;
  String category;

  News(this.nid, this.title, this.content, this.imageUrl, this.date, this.category);

  @override
  String toString() {
    return 'ID: $nid Title: $title Category: $category';
  }
}

List<News> newsList = [];

void updateNews(Function(bool) update) async {
  try {
    newsList.clear();
    final url = Uri.http(baseURL, 'getNews.php');
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty) {
        update(false);
        return;
      }
      try {
        final jsonResponse = convert.jsonDecode(response.body);
        for (var row in jsonResponse) {
          String rawImageUrl = row['image_url'] ?? '';
          String finalImageUrl = rawImageUrl;
          
          // If the image is on our server, use the proxy for CORS compatibility
          if (rawImageUrl.contains('atwebpages.com/uploads/')) {
            String fileName = rawImageUrl.split('uploads/').last;
            finalImageUrl = 'http://fatimamobile.atwebpages.com/view_image.php?path=uploads/' + fileName;
          }

          News n = News(
            int.parse(row['nid']),
            row['title'],
            row['content'],
            finalImageUrl,
            row['published_date'],
            row['category'] ?? 'General'
          );
          newsList.add(n);
        }
        update(true);
      } catch (e) {
        update(false);
      }
    } else {
      update(false);
    }
  } catch (ex) {
    update(false);
  }
}

void searchNews(Function(List<News>) update, String term) async {
  try {
    final url = Uri.http(baseURL, 'searchNews.php', {'term': term});
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      List<News> results = [];
      for (var row in jsonResponse) {
        String rawImageUrl = row['image_url'] ?? '';
        String finalImageUrl = rawImageUrl;
        
        if (rawImageUrl.contains('atwebpages.com/uploads/')) {
          String fileName = rawImageUrl.split('uploads/').last;
          finalImageUrl = 'http://fatimamobile.atwebpages.com/view_image.php?path=uploads/' + fileName;
        }

        News n = News(
          int.parse(row['nid']),
          row['title'],
          row['content'],
          finalImageUrl,
          row['published_date'],
          row['category'] ?? 'General'
        );
        results.add(n);
      }
      update(results);
    } else {
      update([]);
    }
  } catch (ex) {
    print('Error searching news: $ex');
    update([]);
  }
}
