import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';

class NewsService {
  final String _apiKey = '1292c32f90014cda9eb8dedb9c0d251c';
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines({String query = ''}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/top-headlines?country=us&apiKey=$_apiKey${query.isNotEmpty ? '&q=$query' : ''}',
      );

      print('🔗 URL: $url');
      final response = await http.get(url);
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['articles'] != null && data['articles'].isNotEmpty) {
          return (data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList();
        } else {
          print('⚠️ No articles found.');
          return [];
        }
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching news: $e');

      // ✅ Fallback mock data
      return [
        Article(
          title: 'Offline: Mock Headline 1',
          description: 'This is a fallback headline if the API fails.',
          url: 'https://example.com/mock1',
          source: 'Mock Source',
        ),
        Article(
          title: 'Offline: Mock Headline 2',
          description: 'Another example offline headline.',
          url: 'https://example.com/mock2',
          source: 'Mock Source',
        ),
      ];
    }
  }
}
