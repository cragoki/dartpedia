import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/article.dart';

// This code defines the getArticleByTitle function, which uses the http package to make a
// GET request to the Wikipedia APIand returns a List<Article> object.
// This function retrieves the content of a Wikipedia article based on its title.

Future<List<Article>> getArticleByTitle(String title) async {
  final http.Client client = http.Client();
  try {
    final Uri url = Uri.https(
      'en.wikipedia.org',
      '/w/api.php',
      <String, Object?>{
        // order matters - explaintext must come after prop
        'action': 'query',
        'format': 'json',
        'titles': title.trim(),
        'prop': 'extracts',
        'explaintext': '',
      },
    );
    final http.Response response = await client.get(url);
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
      jsonDecode(response.body) as Map<String, Object?>;
      return Article.listFromJson(jsonData);
    } else {
      throw HttpException(
        '[WikipediaApiClient.getArticleByTitle] '
            'statusCode=${response.statusCode}, '
            'body=${response.body}',
      );
    }
  } on FormatException {
    // TODO: log
    rethrow;
  }
  //finally runs whether the try block succeeds or throws. This ensures the client's connections are properly closed, preventing resource leaks.
  finally {
    client.close();
  }
}