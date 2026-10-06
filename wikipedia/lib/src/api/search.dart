import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/search_results.dart';


// This code defines the search function,
// which uses the http package to make a GET request to the Wikipedia API's
// opensearch endpoint and returns a SearchResults object.
// The opensearch endpoint is used to search for Wikipedia articles based on a search term.

Future<SearchResults> search(String searchTerm) async {
  final http.Client client = http.Client();
  try {
    final Uri url = Uri.https(
      'en.wikipedia.org',
      '/w/api.php',
      <String, Object?>{
        'action': 'opensearch',
        'format': 'json',
        'search': searchTerm,
      },
    );
    final http.Response response = await client.get(url);
    if (response.statusCode == 200) {
      final List<Object?> jsonData = jsonDecode(response.body) as List<Object?>;
      return SearchResults.fromJson(jsonData);
    } else {
      throw HttpException(
        '[WikipediaApiClient.search] '
            'statusCode=${response.statusCode}, '
            'body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  }
  //finally runs whether the try block succeeds or throws. This ensures the client's connections are properly closed, preventing resource leaks.
  finally {
    client.close();
  }
}