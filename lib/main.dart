import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product catalog',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello World'),
        )
      ),
    );
  }
}
