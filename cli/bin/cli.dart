import 'dart:io';
import 'package:http/http.dart' as http;

const version = '0.0.1';
const wikipediaUrl = 'en.wikipedia.org'; // Wikipedia API domain
const wikipediaPath = '/api/rest_v1/page/summary/'; // API path for article summary

void main(List<String> arguments) {

  //Help Text
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  }
  //Get current app version
  else if (arguments.first.toLowerCase() == 'version') {
    print('Dartpedia CLI version $version');
  }
  //Search command
  else if (arguments.first.toLowerCase() == 'wikipedia') {
    //Pass to search any arguments after the word 'search'
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  }
  //Invalid Argument
  else {
    printUsage();
  }
}

//Available commands option for when an invalid command is entered...
void printUsage() {
  print(
      "The following commands are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>'"
  );
}

//Handle the search function when the user inputs search command
void searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  // If the user didn't pass in arguments, request an article title.
  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    // Await input and provide a default empty string if the input is null.
    final inputFromStdin = stdin.readLineSync();

    //If still no input
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided. Exiting.');
      return; // Exit the function if there's no valid input.
    }
    articleTitle = inputFromStdin;
  } else {
    // Otherwise, join the arguments into a single string.
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent); // Print the full article response (raw JSON for now)

}

//Future indicates that this function will eventually produce a String result, but not immediately,
// because it's asynchronous
Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    '$wikipediaUrl',
    '$wikipediaPath$articleTitle',
  );
  final response = await http.get(url); // Make the HTTP request

  if (response.statusCode == 200) {
    return response.body; // Return the response body if successful
  }

  // Return an error message if the request failed
  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
}