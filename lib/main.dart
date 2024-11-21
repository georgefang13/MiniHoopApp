import 'package:flutter/material.dart';
import 'package:mini_hoop_app/views/leaderboard.dart';

void main() {
  runApp(SwishApp());
}

class SwishApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S.W.I.S.H. Basketball',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'S.W.I.S.H. Basketball',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to S.W.I.S.H. Basketball',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Leaderboard()),
                );
              },
              child: Text('View Leaderboard'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
