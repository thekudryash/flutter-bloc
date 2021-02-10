import 'dart:convert';

import 'package:test_ex/models/post.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<Post>> fetchPosts() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/posts');
    List<dynamic> jsonData = jsonDecode(response.body);

    return jsonData.map((e) => Post.fromJson(e)).toList();
  }
}
