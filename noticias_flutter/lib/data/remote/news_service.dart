import 'dart:convert';
import 'dart:io';
import 'package:noticias_flutter/core/constants/api_constants.dart';
import 'package:noticias_flutter/data/remote/news_dto.dart';
import 'package:http/http.dart' as http;

class NewsService {
  Future<List<NewsDto>> getAllNews(String query) async {
    final Uri uri = Uri.parse(ApiConstants.baseUrl).replace(
      path: ApiConstants.newsEndpoint,
      queryParameters: {'description': query},
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => NewsDto.fromJson(json)).toList();
      }
      return Future.error('Failed to search news: ${response.statusCode}');
    } catch (e) {
      return Future.error('Failed to search news: ${e.toString()}');
    }
  }
}
