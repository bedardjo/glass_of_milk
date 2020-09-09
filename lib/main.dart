import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GlassOfLiquidDemo(),
    );
  }
}

class GlassOfLiquidDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GlassOfLiquidDemoState();
}

class GlassOfLiquidDemoState extends State<GlassOfLiquidDemo> {
  double skew = .2;
  double fullness = .7;
  double ratio = .7;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(children: [
        Expanded(
            child: Center(
          child: Container(
            width: 300,
            height: 400,
            child: CustomPaint(
              painter: GlassOfLiquid(
                  skew: .01 + skew * .4, ratio: ratio, fullness: fullness),
            ),
          ),
        )),
        Slider(
          value: skew,
          onChanged: (newVal) {
            setState(() {
              this.skew = newVal;
            });
          },
        ),
        Slider(
          value: fullness,
          onChanged: (newVal) {
            setState(() {
              this.fullness = newVal;
            });
          },
        ),
        Slider(
          value: ratio,
          onChanged: (newVal) {
            setState(() {
              this.ratio = newVal;
            });
          },
        )
      ]),
    );
  }
}

class GlassOfLiquid extends CustomPainter {
  final double skew;
  final double ratio;
  final double fullness;

  GlassOfLiquid({this.skew, this.ratio, this.fullness});

  @override
  void paint(Canvas canvas, Size size) {
    Paint glass = Paint()
      ..color = Colors.white.withAlpha(150)
      ..style = PaintingStyle.fill;
    Paint milkTopPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint milkColor = Paint()
      ..color = Color.fromARGB(255, 235, 235, 235)
      ..style = PaintingStyle.fill;
    Paint black = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Rect top = Rect.fromLTRB(0, 0, size.width, size.width * skew);
    Rect bottom = Rect.fromCenter(
        center: Offset(
            size.width * .5, size.height - size.width * .5 * skew * ratio),
        width: size.width * ratio,
        height: size.width * skew * ratio);

    Rect liquidTop = Rect.lerp(bottom, top, fullness);

    Path cupPath = Path()
      ..moveTo(top.left, top.top + top.height * .5)
      ..arcTo(top, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(top.left, top.top + top.height * .5);

    Path liquidPath = Path()
      ..moveTo(liquidTop.left, liquidTop.top + liquidTop.height * .5)
      ..arcTo(liquidTop, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(liquidTop.left, liquidTop.top + liquidTop.height * .5);

    canvas.drawPath(cupPath, glass);
    canvas.drawPath(liquidPath, milkColor);
    canvas.drawOval(liquidTop, milkTopPaint);
    canvas.drawPath(cupPath, black);
    canvas.drawOval(top, black);
  }

  @override
  bool shouldRepaint(GlassOfLiquid old) =>
      old.fullness != fullness || old.skew != skew || old.ratio != ratio;
}
