import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final Color color;
  final int shots;
  final int makes;

  PlayerCard(
      {required this.name,
      required this.color,
      required this.shots,
      required this.makes});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 10),
            Text('Total Shots: $shots'),
            Text('Total Makes: $makes'),
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
