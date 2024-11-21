class User {
  final String name;
  // final Color color;
  final int shotsMade;
  final int shotsTaken;
  // final double shootingPercentage;
  // final Map<String, double?> heatMap;

  User({
    required this.name,
    // required this.color,
    required this.shotsMade,
    required this.shotsTaken,
    // this.shootingPercentage,
    // required this.heatMap,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      // color: json['color'],
      shotsMade: json['shotsMade'],
      shotsTaken: json['shotsTaken'],
      // shootingPercentage: json['shootingPercentage'].toDouble(),
      // heatMap: (json['heatMap'] as Map<String, dynamic>).map(
      //   (key, value) => MapEntry(key, value?.toDouble()),
      // ),
    );
  }
}
