// leaderboard is a page of user cards, ordered by shooting percentage (or alphabetically?)
// also contains a search bar

import 'package:flutter/material.dart';
import 'package:mini_hoop_app/models/user.dart';
import 'package:mini_hoop_app/services/stats_service.dart';
import 'package:mini_hoop_app/widgets/player_card.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  late Future<List<User>> futureUserStats;

  @override
  void initState() {
    super.initState();
    futureUserStats = StatsService().fetchAllUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Stats')),
      body: FutureBuilder<List<User>>(
        future: futureUserStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final userStats = snapshot.data!;
            return ListView.builder(
              itemCount: userStats.length,
              itemBuilder: (context, index) {
                final user = userStats[index];
                return PlayerCard(
                  name: user.name,
                  // color: Colors.blue,
                  shotsTaken: user.shotsTaken,
                  shotsMade: user.shotsMade,
                );
              },
            );
          }
        },
      ),
    );
  }
}
