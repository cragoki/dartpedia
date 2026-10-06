import 'dart:async';
import 'dart:io';


//Import the necessary packages like command_runner, logging, and wikipedia to use their classes and functions.
import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

class GetArticleCommand extends Command {
  //Accept a Logger instance through their constructor. This is dependency injection,
  // which allows the command to log events without needing to create its own logger.
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get description => 'Read an article from Wikipedia';

  @override
  String get name => 'article';

  @override
  String get help => 'Gets an article by exact canonical wikipedia title.';

  @override
  String get defaultValue => 'cat';

  @override
  String get valueHelp => 'STRING';

  //Implement a run method that defines the command's logic.
  // This method calls the appropriate wikipedia API and formats the output.
  @override
  FutureOr<String> run(ArgResults args) async {
    //Include try/catch blocks to gracefully handle network errors (HttpException)
    // and data parsing errors (FormatException), logging them for debugging.
    try {
      var title = args.commandArg ?? defaultValue;
      final List<Article> articles = await getArticleByTitle(title);
      // API returns a list of articles, but we only care about the closest hit.
      final article = articles.first;
      final buffer = StringBuffer('\n=== ${article.title.titleText} ===\n\n');
      buffer.write(article.extract.split(' ').take(500).join(' '));
      return buffer.toString();
    } on HttpException catch (e) {
      logger
        ..warning(e.message)
        ..warning(e.uri)
        ..info(usage);
      return e.message;
    } on FormatException catch (e) {
      logger
        ..warning(e.message)
        ..warning(e.source)
        ..info(usage);
      return e.message;
    }
  }
}