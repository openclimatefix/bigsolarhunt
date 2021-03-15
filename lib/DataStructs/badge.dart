class Badge {
  Badge(
      {this.id,
      this.imagePath,
      this.panelCount,
      this.unlocked,
      this.dateUnlocked,
      this.description});

  String id;
  String imagePath;
  int panelCount;
  bool unlocked;
  DateTime dateUnlocked;
  String description;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'imagePath': imagePath,
      'panelCount': panelCount == null ? 'NULL' : panelCount,
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
      panelCount: json['panelCount'] == 'NULL' ? null : json['panelCount'],
      unlocked: json['unlocked'] == 1,
      dateUnlocked: json['dateUnlocked'] == 'NULL'
          ? null
          : DateTime.parse(json['dateUnlocked']),
      description: json['description']);
}

List<int> panelCountBadgeIntegers = [5, 20, 50];

List<Badge> panelCountBadges = panelCountBadgeIntegers
    .map((i) => Badge(
        id: "$i Panels",
        imagePath: 'assets/badges/$i-panels.png',
        panelCount: i,
        unlocked: false,
        dateUnlocked: null,
        description: 'Submit $i panels'))
    .toList();

List<Badge> miscBadges = [
  Badge(
      id: "Streak",
      imagePath: 'assets/badges/streak.png',
      panelCount: null,
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit at least one panel every day for 5 days in a row'),
  Badge(
      id: "Explorer",
      imagePath: 'assets/badges/explorer.png',
      panelCount: null,
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 2 panels over 200 miles apart'),
  Badge(
      id: "Anti Explorer",
      imagePath: 'assets/badges/anti-explorer.png',
      panelCount: null,
      unlocked: false,
      dateUnlocked: null,
      description: 'Submit 2 panels in close proximity')
];

List<Badge> initialBadges = panelCountBadges + miscBadges;
