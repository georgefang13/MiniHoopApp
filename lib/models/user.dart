class User {
  final int id;
  final String name;
  int? shotsMade;
  int? shotsTaken;
  double? percentage;
  List<double>? percentageByRegion;

  User({
    required this.id,
    required this.name,
    this.shotsMade,
    this.shotsTaken,
    this.percentage,
  });
}
