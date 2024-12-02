import 'package:flutter/material.dart';
import 'package:mini_hoop_app/models/user.dart';
import 'package:mini_hoop_app/views/profile.dart';

class PlayerCard extends StatelessWidget {
  final User user;
  final Color color;
  final double shootingPercentage;

  PlayerCard({
    required this.user,
    Color? color,
    required this.shootingPercentage,
  }) : color = color ?? Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileView(
                      user: user,
                      shootingPercentage: shootingPercentage,
                    )),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.person,
                  color: color,
                ),
              ),
              SizedBox(width: 5.0),
              Text(
                user.name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(width: 10.0),
              Text(
                'Shooting Percentage: $shootingPercentage% (${user.shotsMade} / ${user.shotsTaken})',
                style: TextStyle(color: Colors.grey.shade900, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
