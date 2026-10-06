import 'package:command_runner/command_runner.dart';
import 'package:cli/cli.dart';

const version = '0.0.1';


// This setup initializes an errors file logger, passes it to SearchCommand and GetArticleCommand,
// and registers all commands with CommandRunner.
void main(List<String> arguments) async {
  final errorLogger = initFileLogger('errors');
  final app =
  CommandRunner(
    onOutput: (String output) async {
      await write(output);
    },
    onError: (Object error) {
      if (error is Error) {
        errorLogger.severe(
          '[Error] ${error.toString()}\n${error.stackTrace}',
        );
        throw error;
      }
      if (error is Exception) {
        errorLogger.warning(error);
        print(error);
      }
    },
  )
    ..addCommand(HelpCommand())
    ..addCommand(SearchCommand(logger: errorLogger))
    ..addCommand(GetArticleCommand(logger: errorLogger));

  app.run(arguments);
}