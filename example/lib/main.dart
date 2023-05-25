import 'dart:math';

import 'package:flutter/material.dart';
import 'package:popup/popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Popup Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 50,
            top: 100,
            child: _buildChild(PopPosition.top),
          ),
          Positioned(
            left: 150,
            bottom: 100,
            child: _buildChild(PopPosition.bottom),
          ),
          Positioned(
            left: 100,
            top: 300,
            child: _buildChild(PopPosition.left),
          ),
          Positioned(
            right: 100,
            top: 300,
            child: _buildChild(PopPosition.right),
          ),
        ],
      ),
    );
  }

  Builder _buildChild(PopPosition position) {
    var name = position.name.split(".").first;
    return Builder(builder: (context) {
      return GestureDetector(
        onLongPress: () {
          showPopup(
              position: position,
              context: context,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  List.generate(Random().nextInt(10) + 3, (index) => name).toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ));
        },
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          width: 100,
          height: 100,
          child: Center(
            child: Text(name),
          ),
        ),
      );
    });
  }
}
