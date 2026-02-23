import 'dart:io';

import 'package:final_cleaner/cli/cli_app.dart';

void main(List<String> args) async {
  exit(await CliApp().run(args));
}
