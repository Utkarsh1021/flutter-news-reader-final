import 'package:flutter/material.dart';
import 'package:news_reader_app/news_service.dart';
import 'package:news_reader_app/news_detail.dart';
import 'package:news_reader_app/news_model.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<Article> _articles = [];
  bool _isLoading = true;
  String _query = "";

  Future<void> _fetchArticles() async {
    setState(() => _isLoading = true);
    _articles = await NewsService().fetchTopHeadlines(query: _query);
    print('Fetched ${_articles.length} articles');
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: NewsSearchDelegate(onQueryChanged: (query) {
                  _query = query;
                  _fetchArticles();
                }),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchArticles,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _articles.isEmpty
                ? const Center(child: Text('No news available.', style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return ListTile(
                        title: Text(article.title),
                        subtitle: Text(article.source),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailScreen(article: article),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final Function(String) onQueryChanged;
  NewsSearchDelegate({required this.onQueryChanged});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    onQueryChanged(query);
    close(context, null);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
