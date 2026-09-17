import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/product_provider.dart';
import 'presentation/screens/product_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider()..fetchProducts(), // Automatically fetches on startup
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product catalog',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}
