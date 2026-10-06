# Dart Tutorial

A README for the official Dart tutorial, which teaches Dart by building an interactive command-line (CLI) application. https://dart.dev/learn/tutorial

## Prerequisites
* Dart SDK installed (sets up the dart CLI used throughout)
* Basic familiarity with general programming concepts — the tutorial is beginner-friendly but does not cover programming fundamentals

## Lessons

The tutorial has 13 lessons, building the CLI app up step by step:

1. Build your first app
2. Add interactivity to your app
3. Write asynchronous code
4. Organize code with packages and libraries
5. Define classes and objects
6. Structure apps with inheritance
7. Handle errors gracefully
8. Extend your app with enums and extensions
9. Polish your CLI app
10. Work with JSON data
11. Test your app & code
12. Fetch data from the internet
13. Add logging for debugging and monitoring

## Usable Commands

|Command|Purpose|
|  ---  |  ---  |
|`dart pub get`|Fetch/install the project's dependencies before running it|
|`dart run bin/cli.dart search "Dart programming"`|Run the app's `search` command with a query|
|`dart run bin/cli.dart search "Dart" --im-feeling-lucky`|Run `search` with the `--im-feeling-lucky` flag to jump straight to the first result|
|`dart test`|Run the test suite added in the "Test your app & code" lesson|
|`dart compile exe bin/cli.dart -o cli`|Compile the app to a standalone native executable|

