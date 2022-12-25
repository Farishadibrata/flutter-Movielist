import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttermovie/Movie/model.dart';
import 'package:http/http.dart' as http;

Future<List<Results>?> fetchMovie() async {
  final response = await http
      .get(Uri.parse("https://api.themoviedb.org/3/trending/all/day?api_key=${dotenv.env['API_KEY']}"));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed =  Movies.fromJson(jsonDecode(response.body));
    return parsed.results;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Movie');
  }
}