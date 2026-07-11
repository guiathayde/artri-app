import 'package:artriapp/database/index.dart';
import 'package:artriapp/views/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final database =
      await $FloorAppDatabase.databaseBuilder('artriapp.db').build();

  runApp(App(database: database));
}
