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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(microseconds: 1);
  late Timer _counterTimer;

  //начальные точки главного треугольника
  final List<Point> _points = [];

  bool _isAutoPaintingFractal = false;

  @override
  void initState() {
    super.initState();
    _counterTimer = Timer.periodic(_duration, (timer) {
      if (_isAutoPaintingFractal) {
        _calculateFractal();
      }
    });
  }

  void _calculateFractal() {
    var randVertex = (Random().nextDouble() * 3).floor();
    var randPoint = (Random().nextDouble() * _points.length).floor();

    var x = _points[randVertex].horizontal +
        (_points[randPoint].horizontal - _points[randVertex].horizontal) / 2;
    var y = _points[randVertex].vertical +
        (_points[randPoint].vertical - _points[randVertex].vertical) / 2;
    var point = Point(
      horizontal: x,
      vertical: y,
    );
    setState(() {
      _points.add(point);
    });
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
        child: _isAutoPaintingFractal
            ? Stack(
                children: _points,
              )
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Stack(
                  children: _points,
                ),
                onTapDown: (tap) {
                  double x = tap.localPosition.dx.floorToDouble();
                  double y = tap.localPosition.dy.floorToDouble();

                  setState(() {
                    _points.add(Point(
                      vertical: y,
                      horizontal: x,
                      size: 3,
                    ));
                  });

                  if (_points.length == 3) {
                    _isAutoPaintingFractal = true;
                  }
                },
              ),
      ),
    );
  }
}

class Point extends StatelessWidget {
  const Point(
      {Key? key,
      required this.vertical,
      required this.horizontal,
      this.size = 1.5})
      : super(key: key);
  final double vertical;
  final double horizontal;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: horizontal,
      top: vertical,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
