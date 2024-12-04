// leaderboard is a page of user cards, ordered by shooting percentage (or alphabetically?)
// also contains a search bar

import 'package:flutter/material.dart';
import 'package:mini_hoop_app/models/user.dart';
import 'package:mini_hoop_app/services/stats_service.dart';
import 'package:mini_hoop_app/widgets/player_card.dart';

enum FilterType {
  alphabetical('Alphabetically', 1),
  percent('By Percentage', 2),
  totalShots('By Shots Taken', 3);

  const FilterType(this.label, this.rank);
  final String label;
  final int rank;
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  late Future<List<User>> futureUserStats;

  TextEditingController filterController = TextEditingController();

  FilterType? sortType;

  @override
  void initState() {
    super.initState();
    futureUserStats = StatsService().fetchAllUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75.0,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: DropdownMenu<FilterType>(
              trailingIcon: Icon(Icons.arrow_drop_up),
              enableSearch: false,
              initialSelection: FilterType.alphabetical,
              controller: filterController,
              // requestFocusOnTap is enabled/disabled by platforms when it is null.
              // On mobile platforms, this is false by default. Setting this to true will
              // trigger focus request on the text field and virtual keyboard will appear
              // afterward. On desktop platforms however, this defaults to true.
              requestFocusOnTap: true,
              label: Text('Filter...'),
              onSelected: (FilterType? filter) {
                setState(() {
                  sortType = filter;
                });
              },
              dropdownMenuEntries: FilterType.values
                  .map<DropdownMenuEntry<FilterType>>((FilterType filter) {
                return DropdownMenuEntry<FilterType>(
                  value: filter,
                  label: filter.label,
                );
              }).toList(),
            ),
          ),
        ],
      ),
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
            // sort by filter
            (sortType == FilterType.percent)
                ? snapshot.data!.sort((a, b) => b
                    .getShootingPercentage()
                    .compareTo(a.getShootingPercentage()))
                : (sortType == FilterType.totalShots)
                    ? snapshot.data!
                        .sort((a, b) => b.shotsTaken.compareTo(a.shotsTaken))
                    : snapshot.data!.sort((a, b) => (a.name.compareTo(b.name)));
            return ListView.builder(
              itemCount: userStats.length,
              itemBuilder: (context, index) {
                final user = userStats[index];
                return PlayerCard(
                  user: user,
                  // color: Colors.blue,
                  shootingPercentage: user.getShootingPercentage(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
