import 'package:flutter_test/flutter_test.dart';
import 'package:args/command_runner.dart';
import 'package:final_cleaner/cli/commands/group_command.dart';

void main() {
  late CommandRunner<void> runner;

  setUp(() {
    runner = CommandRunner('test', 'test description')
      ..addCommand(GroupCommand());
  });

  group('GroupCommand', () {
    test('prints help information', () async {
      final output = await captureStdout(() => runner.run(['group', '--help']));
      expect(
        output,
        contains('Usage'),
      ); // Adjust according to actual help output
    });
    // Add additional tests as needed
  });
}
