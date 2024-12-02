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
    // Load the asset image as a ui.Image
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

  // define color range
  // List<HSVColor> get colorList => List<HSVColor>.generate(11, (i) {
  //       double t = i / 10;
  //       return HSVColor.lerp(startColor, endColor, t)!;
  //     });

  // List<Color> colorArr = [Colors.red, Colors.blue];
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
      int zonePctIndex = (zonePct - 1) ~/ 10;
      Color zoneColor = colorList[zonePctIndex];
      overlayPaint.color = zoneColor.withOpacity(0.75);

      // Draw a pie-shaped segment
      canvas.drawPath(
        Path()
          ..moveTo(centerX, centerY)
          ..arcTo(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            -pi + i * segmentAngle, // Start angle
            segmentAngle, // Sweep angle
            false,
          )
          ..close(),
        overlayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever properties change
  }
}





//   List<HSVColor> get colorList => List<HSVColor>.generate(steps, (i) {
//         double t = i / steps;
//         return HSVColor.lerp(startColor, endColor, t)!;
//       });

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw the background image scaled to fit
//     canvas.drawArc(Rect.largest, 0, pi, true, Paint());

//     // // Paint heatmap points
//     // Paint heatPaint = Paint()
//     //   ..color = Colors.red.withOpacity(0.5)
//     //   ..style = PaintingStyle.fill;

//     // for (final point in heatmap) {
//     //   canvas.drawCircle(point, 20, heatPaint); // Example circle for heatmap
//     // }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }

//   HSVColor getFillColor(percentage) {
//     int ind = percentage ~/ 10;
//     return colorList[ind];
//   }
// }


// class _CalendarPainter extends CustomPainter {
//   final DateTime dateTime;
//   final Color iconColor;
//   final Color textColor;

//   _CalendarPainter({
//     required this.dateTime,
//     required this.iconColor,
//     required this.textColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     IconData icon = FontAwesomeIcons.solidCalendar;
//     // Paint the calendar icon
//     TextPainter iconPainter = TextPainter(
//         text: TextSpan(
//           text: String.fromCharCode(icon.codePoint),
//           style: TextStyle(
//               fontSize:
//                   size.width, // This will make the icon take the full width
//               fontFamily: icon.fontFamily,
//               package: icon.fontPackage,
//               color: iconColor),
//         ),
//         textDirection: TextDirection.ltr);
//     iconPainter.layout();
//     iconPainter.paint(canvas, Offset(4, 0));

//     // Paint the name of the day
//     final dayName = DateFormat('EEEE', 'en_US').format(dateTime).toUpperCase();
//     final TextPainter monthPainter = TextPainter(
//       text: TextSpan(
//         text: dayName,
//         style: TextStyle(
//           fontFamily: 'Oswald',
//           fontWeight: FontWeight.w600,
//           fontSize: size.width / 5.9, // Adjust as needed
//           color: textColor,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//     monthPainter.layout();
//     monthPainter.paint(
//       canvas,
//       Offset(
//         size.width / 2 - monthPainter.width / 2, // Centering horizontally
//         size.height * .11, // Placing above the day number
//       ),
//     );

//     // Paint the number of the month
//     final dayNumber = DateFormat.d().format(dateTime);
//     final TextPainter dayPainter = TextPainter(
//         text: TextSpan(
//           text: dayNumber,
//           style: TextStyle(
//               fontFamily: 'Oswald',
//               fontWeight: FontWeight.w800,
//               fontSize: size.width * .6, // Adjust as needed
//               color: textColor),
//         ),
//         textDirection: TextDirection.ltr);
//     dayPainter.layout();
//     dayPainter.paint(
//       canvas,
//       Offset(
//         size.width / 2 - dayPainter.width / 2, // Centering horizontally
//         size.height * .2, // Centering vertically
//       ),
//     );
//   }
