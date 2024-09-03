import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:s_template/app.dart';
import 'package:s_template/injection.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  runApp(const App());
}
