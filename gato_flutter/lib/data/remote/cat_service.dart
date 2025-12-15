import 'dart:convert';
import 'dart:io';
import 'package:gato_flutter/core/constants/api_constants.dart';
import 'package:gato_flutter/data/remote/cat_dto.dart';
import 'package:gato_flutter/data/remote/home_image_dto.dart';
import 'package:http/http.dart' as http;

class CatService {
  Future<List<CatDto>> getAllCats() async {
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.catsEndpoint}',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final List jsons = jsonDecode(response.body);
        return jsons.map((json) => CatDto.fromJson(json)).toList();
      }
      return Future.error('Failed to fetch cats: ${response.statusCode}');
    } catch (e) {
      return Future.error('Failed to fetch cats: ${e.toString()}');
    }
  }

  Future<HomeImageDto> getHomeImage() async {
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.imageHomeEndpoint}',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final List jsons = jsonDecode(response.body);
        if (jsons.isNotEmpty) {
          return HomeImageDto.fromJson(jsons[0]);
        }
        return Future.error('No image available');
      }
      return Future.error('Failed to fetch home image: ${response.statusCode}');
    } catch (e) {
      return Future.error('Failed to fetch home image: ${e.toString()}');
    }
  }
}
