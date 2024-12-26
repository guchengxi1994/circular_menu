import 'package:another_circular_menu/another_circular_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyItem extends Item {
  MyItem({required super.index, required super.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Text(index.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final BoardController<MyItem> _controller = BoardController(items: [
    MyItem(index: 0, onItemSelected: (_) {}),
    MyItem(index: 1, onItemSelected: (_) {}),
    MyItem(index: 2, onItemSelected: (_) {}),
    MyItem(index: 3, onItemSelected: (_) {}),
    MyItem(index: 4, onItemSelected: (_) {}),
    MyItem(index: 5, onItemSelected: (_) {}),
    MyItem(index: 6, onItemSelected: (_) {}),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularMenu(
          controller: _controller,
        ),
      ),
    );
  }
}
