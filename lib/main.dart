import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_betting_simulator/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(SportsApp(sharedPreferences: sharedPreferences));
}
