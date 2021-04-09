import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:solar_hunt/DataStructs/solar_panel.dart';
import 'package:solar_hunt/DataStructs/badge.dart';
import 'package:solar_hunt/DataStructs/upload_queue_item.dart';
import 'package:solar_hunt/Services/latlong_services.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider databaseProvider = DatabaseProvider._();
  Database _database;
  static const String _panelDatabaseName = 'panel_database';
  static const String _userPanelTableName = 'userPanels';
  static const String _userBadgeTableName = "userBadges";
  static const String _uploadQueueTableName = 'uploadQueue';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Database database = await openDatabase(
        join(await getDatabasesPath(), _panelDatabaseName),
        onCreate: _onCreate,
        version: 1);
    return database;
  }

  Future<void> _onCreate(Database db, int newVersion) async {
    await createUserPanelsTable(db);
    await createAndPopulateUserBadgesTable(db);
    await createUploadQueueTable(db);
  }

  Future<void> createUploadQueueTable(Database db) async {
    await db.execute("CREATE TABLE $_uploadQueueTableName("
        "path TINYTEXT,"
        "lat FLOAT,"
        "lon FLOAT"
        ")");
  }

  Future<void> createUserPanelsTable(Database db) async {
    await db.execute("CREATE TABLE IF NOT EXISTS $_userPanelTableName("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "lat FLOAT,"
        "lon FLOAT,"
        "date TEXT"
        ")");
  }

  Future<void> createAndPopulateUserBadgesTable(Database db) async {
    await db.execute("CREATE TABLE $_userBadgeTableName("
        "id TEXT PRIMARY KEY,"
        "imagePath TEXT,"
        "panelCount INTEGER,"
        "unlocked INTEGER,"
        "dateUnlocked TEXT,"
        "description TEXT"
        ")");
    Future.forEach(initialBadges, (badgeRow) async {
      await db.insert(_userBadgeTableName, badgeRow.toMap());
    });
  }

  Future<List<SolarPanel>> getUserPanelData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> response =
        await db.rawQuery("SELECT * FROM $_userPanelTableName");
    List<SolarPanel> panelData =
        response.map((row) => SolarPanel.fromMap(row)).toList();
    return panelData;
  }

  Future<int> getUserPanelCount() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT COUNT (*) FROM $_userPanelTableName");
    int count = Sqflite.firstIntValue(result);
    return count;
  }

  Future<int> getUploadQueueCount() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT COUNT (*) FROM $_uploadQueueTableName");
    int count = Sqflite.firstIntValue(result);
    return count;
  }

  Future<List<Badge>> getUserBadgeData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> response =
        await db.rawQuery("SELECT * FROM $_userBadgeTableName");
    List<Badge> badgeData = response.map((row) => Badge.fromMap(row)).toList();
    return badgeData;
  }

  Future<void> insertUserPanel(SolarPanel newPanel) async {
    final Database db = await database;
    await db.insert(_userPanelTableName, newPanel.toMapNoID());
  }

  Future<void> insertQueueData(
      String imagePath, double panelLat, double panelLon) async {
    final Database db = await database;
    final toUpload =
        UploadQueueItem(path: imagePath, lat: panelLat, lon: panelLon);
    await db.insert(_uploadQueueTableName, toUpload.toMap());
  }

  Future<List<UploadQueueItem>> getUploadQueue() async {
    final Database db = await database;
    final List<Map<String, dynamic>> response =
        await db.rawQuery("SELECT * FROM $_uploadQueueTableName");
    List<UploadQueueItem> uploadQueue =
        response.map((row) => UploadQueueItem.fromMap(row)).toList();
    return uploadQueue;
  }

  Future<void> deleteFromUploadQueue(UploadQueueItem toDelete) async {
    final Database db = await database;
    final String path = toDelete.path;
    await db.delete(
      _uploadQueueTableName,
      where: "path = ?",
      whereArgs: [path],
    );
  }

  Future<List<Badge>> checkForNewBadges(SolarPanel lastUploadedPanel) async {
    // Checks the badge table to see whether any new badges have been earned
    // Updates the table accordingly
    final Database db = await database;
    List<Badge> userBadges = await getUserBadgeData();
    List<SolarPanel> currentPanels = await getUserPanelData();
    int userPanels = await getUserPanelCount();
    List<Badge> newBadges = [];

    unlockBadgeOfId(String id, List<Badge> newBadgeList) async {
      // Get badge to be unlocked from current badge table list
      Badge unlockedBadge = userBadges.singleWhere((badge) => badge.id == id);
      // Set the badge to unlocked
      unlockedBadge.unlocked = true;
      unlockedBadge.dateUnlocked = DateTime.now();
      // Add the new badge to the newbadge list
      newBadgeList.add(unlockedBadge);
      // Replace table entry for newly unlocked badge with unlocked version
      await db.insert(_userBadgeTableName, unlockedBadge.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    checkPanelCountBadges() {
      // Check panel count badges
      Badge newBadge = userBadges.singleWhere(
          (badge) => (badge.unlocked == false &&
              badge.panelCount != null &&
              badge.panelCount <= userPanels),
          orElse: () => null);
      if (newBadge != null) {
        unlockBadgeOfId(newBadge.id, newBadges);
      }
    }

    checkExplorerBadge() {
      // Get greatest distance between current panel and all other panels
      double distance = currentPanels
          .map((panel) {
            try {
              return getDistanceFromLatLonInKm(lastUploadedPanel.lat,
                  lastUploadedPanel.lon, panel.lat, panel.lon);
            } on Exception {
              return -1.0;
            }
          })
          .toList()
          .reduce(max);

      // Check if unlocked
      Badge explorerBadge = userBadges.singleWhere(
          (badge) => (badge.unlocked == false &&
              badge.id == "Explorer" &&
              distance >= 322.8),
          orElse: () => null);
      if (explorerBadge != null) {
        unlockBadgeOfId(explorerBadge.id, newBadges);
      }
    }

    checkAntiExplorerBadge() {
      // Get smallest distance between current panel and all other panels
      double distance = currentPanels
          .map((panel) {
            try {
              return getDistanceFromLatLonInKm(lastUploadedPanel.lat,
                  lastUploadedPanel.lon, panel.lat, panel.lon);
            } on Exception {
              return -1.0;
            }
          })
          .toList()
          .reduce(min);

      // Check if unlocked
      Badge explorerBadge = userBadges.singleWhere(
          (badge) => (badge.unlocked == false &&
              badge.id == "Anti Explorer" &&
              distance <= 0.1 &&
              distance > 0.0),
          orElse: () => null);
      if (explorerBadge != null) {
        unlockBadgeOfId(explorerBadge.id, newBadges);
      }
    }

    checkStreakBadge() {
      // Get badge if not unlocked
      Badge explorerBadge = userBadges.singleWhere(
          (badge) => (badge.unlocked == false && badge.id == "Streak"),
          orElse: () => null);
      if (explorerBadge == null) {
        return;
      }
      // Check if five conecutive days have had submitted panels
      DateTime now = DateTime.now();
      if ([1, 2, 3, 4, 5]
              .map((i) => currentPanels.firstWhere(
                  (panel) =>
                      panel.date
                          .difference(now.subtract(Duration(days: i)))
                          .inDays ==
                      0,
                  orElse: () => null))
              .toList()
              .where((item) => item != null)
              .toList()
              .length ==
          5) {
        unlockBadgeOfId(explorerBadge.id, newBadges);
      }
    }

    checkPanelCountBadges();
    checkExplorerBadge();
    checkAntiExplorerBadge();
    checkStreakBadge();

    return newBadges;
  }
}
