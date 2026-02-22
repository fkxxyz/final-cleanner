import 'dart:convert';

import 'package:args/command_runner.dart';

/// Base class for all CLI leaf commands.
///
/// Provides JSON output support and common helpers.
abstract class CliCommand extends Command<void> {
  /// Whether the user requested JSON output via `--json`.
  bool get isJson => globalResults?['json'] as bool? ?? false;

  /// Prints [data] as JSON if `--json` is set, otherwise calls [printHuman].
  void printResult(Object data) {
    if (isJson) {
      print(jsonEncode(data));
    } else {
      printHuman(data);
    }
  }

  /// Override to provide human-readable output for [data].
  void printHuman(Object data);

  /// Throws a [UsageException] with the given [message].
  Never usageError(String message) {
    throw UsageException(message, usage);
  }

  /// Parses a required positional argument at [index] from [argResults.rest].
  /// Throws [UsageException] if missing.
  String requiredArg(int index, String name) {
    final rest = argResults!.rest;
    if (index >= rest.length) {
      usageError('Missing required argument: <$name>');
    }
    return rest[index];
  }

  /// Parses a required integer positional argument at [index].
  int requiredIntArg(int index, String name) {
    final value = requiredArg(index, name);
    final parsed = int.tryParse(value);
    if (parsed == null) {
      usageError('<$name> must be an integer, got: $value');
    }
    return parsed;
  }
}
