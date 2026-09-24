import 'dart:async';
import 'dart:collection';
import 'command_runner_base.dart';

enum OptionType {
  flag,
  option
}

class Option extends CliElement  {
  //this.name = automatically assigns the constructor argument directly to the instance field name.
  Option(this.name, {
    required this.type,
    this.help,
    this.abbr,
    this.defaultValue,
    this.valueHelp,
  });

  @override
  final String name;
  final OptionType type;

  @override
  final String? help;
  final String? abbr;

  @override
  final Object? defaultValue;

  @override
  final String? valueHelp;

  //get usage = dynamically computes the value whenever accessed, ensuring it reflects current state without redundant storage.
  @override
  String get usage {
    if (abbr != null) {
      return '-$abbr,--$name: $help';
    }

    return '--$name: $help';
  }

}


// serves as the data contract for parsed output
class ArgResults {
  Command? command;
  String? commandArg;
  //Associates each Option instance with its parsed user input.
  Map<Option, Object?> options = {};

  //Return true if flag exsits/is true
  bool flag(String name) {
    //Filters map keys to inspect only boolean flags
    for (var option in options.keys.where(
      //ignoring options that take string arguments.
          (option) => option.type == OptionType.flag,
    )) {
      if (option.name == name) {
        return options[option] as bool;
      }
    }
    return false;
  }

  bool hasOption(String name) {
    return options.keys.any((option) => option.name == name);
  }

  ({Option option, Object? input}) getOption(String name) {
    var mapEntry = options.entries.firstWhere(
          (entry) => entry.key.name == name || entry.key.abbr == name,
    );

    //Returns a lightweight, named record grouping both the Option and its value without declaring a separate class.
    return (option: mapEntry.key, input: mapEntry.value);
  }
}


//Both options and commands share core attributes such as a name, help text,
// and a formatted usage string. Defining an abstract base class
// establishes a single contract for both.
abstract class CliElement {
  String get name;
  String? get help;

  // In the case of flags, the default value is a bool.
  // In other options and commands, the default value is a String.
  // NB: flags are just Option objects that don't take arguments
  Object? get defaultValue;
  String? get valueHelp;

  String get usage;
}

//Commands represent actions that users can perform, such as help or search.
// Because commands share properties with Option (like name and usage),
// they also extend CliElement.
abstract class Command extends CliElement {
  @override
  String get name;

  String get description;

  bool get requiresArgument => false;

  //A command needs a reference to the CommandRunner executing it,
  // so it can access global runner state. The late keyword promises Dart that
  // this non-nullable variable is assigned before reading it (when registered
  // with command.runner = this;).
  late CommandRunner runner;

  @override
  String? help;

  @override
  String? defaultValue;

  @override
  String? valueHelp;

  //Encapsulation with _options: Prefixing _options with an underscore (_)
  // makes it library-private, preventing code outside arguments.dart from modifying the list directly.
  final List<Option> _options = [];

  //UnmodifiableSetView: Exposes a read-only view of the command's options,
  //ensuring callers cannot mutate internal state directly.
  UnmodifiableSetView<Option> get options =>
      UnmodifiableSetView(_options.toSet());

  void addFlag(
      String name, {
        String? help,
        String? abbr,
        String? valueHelp,
      }) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: false,
        valueHelp: valueHelp,
        type: OptionType.flag,
      ),
    );
  }

  void addOption(
      String name, {
        String? help,
        String? abbr,
        String? defaultValue,
        String? valueHelp,
      }) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: defaultValue,
        valueHelp: valueHelp,
        type: OptionType.option,
      ),
    );
  }


  FutureOr<Object?> run(ArgResults args);

  @override
  String get usage {
    return '$name:  $description';
  }
}