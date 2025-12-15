class HomeImageDto {
  final String id;
  final String url;
  final int width;
  final int height;

  const HomeImageDto({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory HomeImageDto.fromJson(Map<String, dynamic> json) {
    return HomeImageDto(
      id: json['id'] as String,
      url: json['url'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }
}
