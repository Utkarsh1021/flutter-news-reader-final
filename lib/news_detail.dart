import 'package:flutter/material.dart';
import 'news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.source)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(article.description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(article.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: const Text('Read Full Article'),
            )
          ],
        ),
      ),
    );
  }
}
