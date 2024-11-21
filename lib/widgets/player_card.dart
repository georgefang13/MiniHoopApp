import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  // final Color color;
  final int shotsTaken;
  final int shotsMade;
  final double? shootingPercentage;
  // final Map<int, double>? heatMap;

  PlayerCard({
    required this.name,
    // required this.color,
    required this.shotsTaken,
    required this.shotsMade,
    this.shootingPercentage,
    // this.heatMap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text('Total Shots: $shotsTaken'),
            Text('Total Makes: $shotsMade'),
            Text('Shooting Percentage: ${shootingPercentage ?? 0.0}'),
            SizedBox(height: 20),
            Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 100), // This will be your heat map image
          ],
        ),
      ),
    );
  }
}
