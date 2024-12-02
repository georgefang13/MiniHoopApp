class User {
  final String name;
  // final Color color;
  final int shotsMade;
  final int shotsTaken;
  final double shootingPercentage;
  final Map<int, double> heatMap;

  User({
    required String name,
    // required this.color,
    required this.shotsMade,
    required this.shotsTaken,
    required this.shootingPercentage,
    required this.heatMap,
  }) : name = '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';

  double getShootingPercentage() {
    double percentage = (shotsTaken > 0) ? (shotsMade / shotsTaken) * 100 : 0.0;
    return double.parse(percentage.toStringAsFixed(2));
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      // color: json['color'],
      shotsMade: json['shotsMade'],
      shotsTaken: json['shotsTaken'],
      shootingPercentage: double.tryParse(json['shootingPercentage']) ?? 0.0,
      heatMap: (json['heatMap'] as Map<dynamic, dynamic>).map(
        (key, value) => MapEntry(int.parse(key), value?.toDouble() ?? 0.0),
      ),
    );
  }
}
