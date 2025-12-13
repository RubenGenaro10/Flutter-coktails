import 'package:noticias_flutter/domain/models/news.dart';

class NewsEntity {
  final String title;
  final String? author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String? sourceId;
  final String sourceName;

  const NewsEntity({
    required this.title,
    this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.sourceId,
    required this.sourceName,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'url': url,
      'url_to_image': urlToImage,
      'published_at': publishedAt,
      'content': content,
      'source_id': sourceId,
      'source_name': sourceName,
    };
  }

  factory NewsEntity.fromMap(Map<String, dynamic> map) {
    return NewsEntity(
      title: map['title'] as String,
      author: map['author'] as String?,
      description: map['description'] as String,
      url: map['url'] as String,
      urlToImage: map['url_to_image'] as String,
      publishedAt: map['published_at'] as String,
      content: map['content'] as String,
      sourceId: map['source_id'] as String?,
      sourceName: map['source_name'] as String,
    );
  }

  factory NewsEntity.fromDomain(News news) {
    return NewsEntity(
      title: news.title,
      author: news.author,
      description: news.description,
      url: news.url,
      urlToImage: news.urlToImage,
      publishedAt: news.publishedAt,
      content: news.content,
      sourceId: news.sourceId,
      sourceName: news.sourceName,
    );
  }

  News toDomain({bool isFavorite = true}) {
    return News(
      title: title,
      author: author,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      sourceId: sourceId,
      sourceName: sourceName,
      isFavorite: isFavorite,
    );
  }
}
