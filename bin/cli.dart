import 'dart:io';

import 'package:final_cleanner/cli/cli_app.dart';

void main(List<String> args) async {
  exit(await CliApp().run(args));
}
