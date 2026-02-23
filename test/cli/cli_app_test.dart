import 'package:flutter_test/flutter_test.dart';
import 'package:args/command_runner.dart';
import 'package:final_cleanner/cli/cli_app.dart';

void main() {
  test('CLI app runs with --help', () async {
    final runner = CLIApp().runner;
    final output = await captureStdout(() => runner.run(['--help']));
    expect(output, contains('Usage')); // Adjust according to actual help output
  });
  // Add more CLI tests as needed
}
