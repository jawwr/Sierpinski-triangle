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

class _MyHomePageState extends State<MyHomePage> {
  //начальные точки главного треугольника
  final List<Point> _points = [];

  bool _isAutoPaintingFractal = false;
  List<Function> func = [];

  Future<void> _start() async {
    Future.delayed(const Duration(seconds: 1), () {
      _isAutoPaintingFractal = true;
      var points = List.of(_points);
      _serpinskii(points, 8);
    });

    Future.delayed(const Duration(seconds: 1), () async {
      for (int i = 0; i < func.length; i++) {
        await Future.delayed(const Duration(microseconds: 50), () {
          func[i]();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Point getMid(Point p1, Point p2) {
    return Point(
        vertical: (p1.vertical + p2.vertical) / 2,
        horizontal: (p1.horizontal + p2.horizontal) / 2);
  }

  void _draw(List<Point> points) {
    for (Point p in points) {
      setState(() {
        _points.add(p);
      });
    }
  }

  void _serpinskii(List<Point> points, int degree) {
    func.add(() => _draw(points));
    if (degree > 0) {
      _serpinskii([
        points[0],
        getMid(points[0], points[1]),
        getMid(points[0], points[2]),
      ], degree - 1);
      _serpinskii([
        points[1],
        getMid(points[0], points[1]),
        getMid(points[1], points[2]),
      ], degree - 1);
      _serpinskii([
        points[2],
        getMid(points[2], points[1]),
        getMid(points[0], points[2]),
      ], degree - 1);
    }
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
                    _start();
                  }
                },
              ),
      ),
    );
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
