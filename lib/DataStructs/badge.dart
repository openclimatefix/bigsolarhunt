class Badge {
  Badge(
      {this.id,
      this.imagePath,
      this.unlocked,
      this.dateUnlocked,
      this.description});

  int id;
  String imagePath;
  bool unlocked;
  DateTime dateUnlocked;
  String description;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'imagePath': imagePath,
      'unlocked': unlocked == true ? 1 : 0,
      'dateUnlocked':
          dateUnlocked == null ? 'NULL' : dateUnlocked.toIso8601String(),
      'description': description
    };
    return map;
  }

  factory Badge.fromMap(Map<String, dynamic> json) => new Badge(
      id: json['id'],
      imagePath: json['imagePath'],
      unlocked: json['unlocked'] == 1,
      dateUnlocked: json['dateUnlocked'] == 'NULL'
          ? null
          : DateTime.parse(json['dateUnlocked']),
      description: json['description']);
}

List<Badge> initialBadges = [
  // This ordering is required to be static in order for the
  // checkForNewBadges function to work in database services
  Badge(
      id: 0,
      imagePath: 'assets/badges/level-1.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Reach Level 1'),
  Badge(
      id: 1,
      imagePath: 'assets/badges/level-5.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Reach level 5'),
  Badge(
      id: 2,
      imagePath: 'assets/badges/level-10.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Reach level 10'),
  Badge(
      id: 3,
      imagePath: 'assets/badges/5-panels.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 5 panels'),
  Badge(
      id: 4,
      imagePath: 'assets/badges/20-panels.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 20 panels'),
  Badge(
      id: 5,
      imagePath: 'assets/badges/50-panels.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 50 panels'),
  Badge(
      id: 6,
      imagePath: 'assets/badges/streak.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit at least one panel every day for 5 days in a row'),
  Badge(
      id: 7,
      imagePath: 'assets/badges/explorer.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 2 panels over 200 miles apart'),
  Badge(
      id: 8,
      imagePath: 'assets/badges/streetstrider.png',
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 5 panels in close proximity')
];
