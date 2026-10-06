import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:wikipedia/src/model/article.dart';
import 'package:wikipedia/src/model/search_results.dart';
import 'package:wikipedia/src/model/summary.dart';

const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
const String catExtractJson = './test/test_data/cat_extract.json';
const String openSearchResponse = './test/test_data/open_search_response.json';


//  1. Open your terminal and navigate to the wikipedia directory.
//  2. Run the command dart test.

//Use the group function to group related tests together.
void main() {
  group('deserialize example JSON responses from wikipedia API', () {
    //TEST #1
    test('deserialize Dart Programming Language page summary example data from '
        'json file into a Summary object', () async {
      //Reads the contents of the dart_lang_summary.json file.
      final String pageSummaryInput =
      await File(dartLangSummaryJson).readAsString();

      //Decodes the JSON string into a Map<String, Object?>.
      final Map<String, Object?> pageSummaryMap =
      jsonDecode(pageSummaryInput) as Map<String, Object?>;

      //Creates a Summary object from the map using the Summary.fromJson constructor.
      final Summary summary = Summary.fromJson(pageSummaryMap);

      //Uses the expect function to assert that the canonical property of the titles object is
      // equal to 'Dart_(programming_language)'.
      expect(summary.titles.canonical, 'Dart_(programming_language)');
    });

    //TEST #2
    test('deserialize Cat article example data from json file into '
        'an Article object', () async {
      //Reads the contents of the cat_extract.json file.
      final String articleJson = await File(catExtractJson).readAsString();

      //Decodes the JSON string into a Map<String, Object?>.
      final Map<String, Object?> articleMap =
      jsonDecode(articleJson) as Map<String, Object?>;

      //Creates the List<Article> object from the map using the Article.listFromJson static method.
      final List<Article> articles = Article.listFromJson(articleMap);

      //Uses the expect function to assert that the title property of the first article is equal to 'cat'.
      expect(articles.first.title.toLowerCase(), 'cat');
    });


    //Test #3
    test('deserialize Open Search results example data from json file '
        'into an SearchResults object', () async {
      //Reads the contents of the open_search_response.json file.
      final String resultsString =
      await File(openSearchResponse).readAsString();

      //Decodes the JSON string into a List<Object?>.
      final List<Object?> resultsAsList =
      jsonDecode(resultsString) as List<Object?>;

      //Creates a SearchResults object from the list using the SearchResults.fromJson constructor.
      final SearchResults results = SearchResults.fromJson(resultsAsList);

      //Uses the expect function to assert that the results list has a length greater than 1.
      //(greaterThan(1) is called a 'matcher'
      expect(results.results.length, greaterThan(1));
    });
  });
}