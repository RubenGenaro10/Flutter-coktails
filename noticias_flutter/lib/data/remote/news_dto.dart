import 'package:noticias_flutter/domain/models/news.dart';

class NewsDto {
  final String title;
  final String? author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final Map<String, dynamic> source;

  const NewsDto({
    required this.title,
    this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
  });

  factory NewsDto.fromJson(Map<String, dynamic> json) {
    return NewsDto(
      title: json['title'] as String? ?? '',
      author: json['author'] as String?,
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      content: json['content'] as String? ?? '',
      source: json['source'] as Map<String, dynamic>? ?? {},
    );
  }

  News toDomain() {
    return News(
      title: title,
      author: author,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      sourceId: source['id'] as String?,
      sourceName: source['name'] as String? ?? '',
      isFavorite: false,
    );
  }
}
