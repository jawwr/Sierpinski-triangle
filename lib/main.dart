import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  final Duration _duration = const Duration(microseconds: 10);
  late Timer _counterTimer;

  final List<Point> _widgets = [
    Point(
      vertical: 10,
      horizontal: 700,
    ),
    Point(
      vertical: 600,
      horizontal: 250,
    ),
    Point(
      vertical: 600,
      horizontal: 1200,
    ),
  ];
  int count =  100000;

  @override
  void initState() {
    super.initState();
    _counterTimer = Timer.periodic(_duration, (timer) {
      if(_widgets.length <= count){
        _fractal();
      }else{
        _counterTimer.cancel();
      }
    });
  }

  void _fractal() {
    // for (int i = 0; i < 10000; i++) {
      var randVertex = (Random().nextDouble() * 3).floor();
      var randPoint = (Random().nextDouble() * _widgets.length).floor();

      var x = _widgets[randVertex].horizontal +
          (_widgets[randPoint].horizontal - _widgets[randVertex].horizontal) /
              2;
      var y = _widgets[randVertex].vertical +
          (_widgets[randPoint].vertical - _widgets[randVertex].vertical) / 2;
      var point = Point(
        horizontal: x,
        vertical: y,
      );
      setState(() {
        _widgets.add(point);
      });
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: _widgets,
        ),
      ),
    );
  }
}

class Point extends StatelessWidget {
  Point({Key? key, this.vertical = 0, this.horizontal = 0}) : super(key: key);
  final double vertical;
  final double horizontal;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: horizontal,
      top: vertical,
      child: Container(
        width: 2,
        height: 2,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
