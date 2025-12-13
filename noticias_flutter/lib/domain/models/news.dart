class News {
  final String title;
  final String? author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String? sourceId;
  final String sourceName;
  final bool isFavorite;

  const News({
    required this.title,
    this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.sourceId,
    required this.sourceName,
    required this.isFavorite,
  });

  News copyWith({
    String? title,
    String? author,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
    String? sourceId,
    String? sourceName,
    bool? isFavorite,
  }) {
    return News(
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
