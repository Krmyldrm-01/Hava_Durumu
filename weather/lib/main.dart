import 'package:flutter/material.dart';

import 'HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      theme: ThemeData.dark(), // thme yı dark yaptık
      home: const Homepage(),
    );
  }
}
