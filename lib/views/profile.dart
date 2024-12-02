// user profile page is the home base for a user's information
import 'package:flutter/material.dart';
import 'package:mini_hoop_app/models/user.dart';
import 'package:mini_hoop_app/widgets/heatmap.dart';

class ProfileView extends StatelessWidget {
  User user;
  Color? color;
  double shootingPercentage;

  ProfileView({
    required this.user,
    Color? color,
    required this.shootingPercentage,
  }) : color = color ?? Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          user.name,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  'Player Stats',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text('Shooting Percentage: $shootingPercentage%')),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text('Total Makes: ${user.shotsMade}')),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text('Total Shots: ${user.shotsTaken}')),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  'Heat Map',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Container(
                height: 200,
                width: 400,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: HeatMap(
                  heatMap: user.heatMap,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(children: [
                  Text(
                    'Percentages by Region',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(
                          label: Text('Region',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Percentage',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: user.heatMap.entries
                        .map(
                          (row) => DataRow(
                            cells: [
                              DataCell(Text('${row.key}')),
                              DataCell(Text('${row.value}')),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
