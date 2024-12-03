import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart' hide Image;

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeatMap extends StatefulWidget {
  final String imagePath = 'assets/images/basketball_halfcourt-01.png';
  final Map<int, double> heatMap;

  HeatMap({
    required this.heatMap,
  });

  @override
  _HeatMapState createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  ui.Image? backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    // load asset image as a ui.Image
    final ByteData data = await rootBundle.load(widget.imagePath);
    ui.decodeImageFromList(data.buffer.asUint8List(), (ui.Image img) {
      setState(() {
        backgroundImage = img;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return backgroundImage == null
        ? Center(child: CircularProgressIndicator())
        : CustomPaint(
            painter: _HeatMapPainter(
              backgroundImage: backgroundImage!,
              heatMap: widget.heatMap,
            ),
            child: Container(),
          );
  }
}

class _HeatMapPainter extends CustomPainter {
  final ui.Image backgroundImage;
  final Map<int, double> heatMap;

  _HeatMapPainter({
    required this.backgroundImage,
    required this.heatMap,
  });

  List<Color> colorList = [
    Color(0xFF000080), // Dark Blue
    Color(0xFF0000FF), // Blue
    Color(0xFF4682B4), // Light Blue
    Color(0xFF87CEEB), // Sky Blue
    Color(0xFFFFB6C1), // Light Pink
    Color(0xFFFFA07A), // Salmon Pink
    Color(0xFFFF6347), // Tomato Red
    Color(0xFFFF4500), // Orange Red
    Color(0xFFDC143C), // Crimson
    Color(0xFF8B0000), // Dark Red
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // draw background image
    canvas.drawImageRect(
      backgroundImage,
      Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(),
          backgroundImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    // now draw overlay colors
    Paint overlayPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // bottom center, 5 segments
    double centerX = size.width / 2;
    double centerY = size.height;
    double radius = size.width / 2;
    double segmentAngle = pi / 5;

    for (int i = 0; i < 5; i++) {
      // set color for segment based on percentage
      double zonePct = min(heatMap[i + 1] ?? 0.0, 99.9);
      int zonePctIndex = (zonePct > 60.0) ? 9 : ((zonePct - 1) ~/ 6);
      Color zoneColor = colorList[zonePctIndex];
      overlayPaint.color = zoneColor.withOpacity(0.75);

      // Draw a pie-shaped segment
      canvas.drawPath(
        Path()
          ..moveTo(centerX, centerY)
          ..arcTo(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            -pi + i * segmentAngle,
            segmentAngle,
            false,
          )
          ..close(),
        overlayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
