import 'package:basic_navigation/app/view/app.dart';
import 'package:basic_navigation/core/di/injection.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const App());
}
