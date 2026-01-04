import 'package:flutter/material.dart';
import 'news.dart';
import 'home.dart'; // To reuse NewsCard

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<News> _results = [];
  bool _searching = false;
  bool _searched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    FocusScope.of(context).unfocus(); // Close keyboard
    setState(() {
      _searching = true;
      _searched = true;
      _results = [];
    });

    searchNews((results) {
       setState(() {
         _results = results;
         _searching = false;
       });
    }, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Term',
                hintText: 'Enter keywords...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          Expanded(
            child: _searching
              ? const Center(child: CircularProgressIndicator())
              : _results.isEmpty && _searched
                ? const Center(child: Text('No nrticles found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      return NewsCard(news: _results[index]);
                    },
                  ),
          )
        ],
      ),
    );
  }
}