class Article {
  final String title;
  final String description;
  final String url;
  final String source;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      source: json['source']['name'] ?? '',
    );
  }
}
