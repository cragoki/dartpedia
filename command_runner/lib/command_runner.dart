//Declares this file as a 'library'
library;

//In Dart packages, files inside lib/src/ are private implementation details.
// Exporting src/exceptions.dart from lib/command_runner.dart exposes ArgumentException as part
// of the package's public API so callers (like cli.dart) can import and use it.

export 'src/arguments.dart';
export 'src/command_runner_base.dart';
export 'src/help_command.dart';
export 'src/exceptions.dart';
export 'src/console.dart';
