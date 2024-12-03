// user profile page is the home base for a user's information
import 'package:flutter/material.dart';
import 'package:mini_hoop_app/models/user.dart';
import 'package:mini_hoop_app/widgets/heatmap.dart';

class ProfileView extends StatelessWidget {
  final User user;
  final Color? color;
  final double shootingPercentage;

  ProfileView({
    required this.user,
    Color? color,
    required this.shootingPercentage,
  }) : color = color ?? Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5BD),
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(
          user.name,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black54, width: 2.0),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Player Stats',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  'Shooting Percentage: $shootingPercentage%  ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                          WidgetSpan(
                              child: (user.shootingPercentage < 20.0)
                                  ? Icon(
                                      Icons.sick_outlined,
                                      color: Colors.blue,
                                    )
                                  : (user.shootingPercentage < 30.0)
                                      ? Icon(Icons.severe_cold_sharp)
                                      : (user.shootingPercentage > 40.0)
                                          ? Icon(Icons.fireplace)
                                          : Icon(Icons.sentiment_satisfied))
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Total Makes: ${user.shotsMade}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    SizedBox(height: 10.0),
                    Text(
                      'Total Shots: ${user.shotsTaken}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black54, width: 2.0),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Heat Map',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 300,
                      width: 600,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: HeatMap(
                        heatMap: user.heatMap,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Column(children: [
                        DataTable(
                          columns: [
                            DataColumn(
                                label: Text('Zone',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Shooting %',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: user.heatMap.entries
                              .map(
                                (row) => DataRow(
                                  cells: [
                                    DataCell(Text('${row.key}')),
                                    DataCell(Text('${row.value}%')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
