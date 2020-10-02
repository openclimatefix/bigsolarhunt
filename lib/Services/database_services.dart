import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_locations_distance/flutter_locations_distance.dart';

import 'package:solar_streets/DataStructs/solar_panel.dart';
import 'package:solar_streets/DataStructs/badge.dart';
import 'package:solar_streets/DataStructs/upload_queue_item.dart';
import 'package:solar_streets/Progress/progress_utilities.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider databaseProvider = DatabaseProvider._();
  Database _database;

  static const String _panelDatabaseName = 'osm_panel_database.db';
  static const String _osmPanelTableName = 'panels';
  static const String _userPanelTableName = 'userPanels';
  static const String _userBadgeTableName = "userBadges";
  static const String _dbLastUpdated = 'last_updated';
  static const String _uploadQueueTableName = 'uploadQueue';

  static const List<String> _osmBaseURL = [
    'http://overpass-api.de/api/interpreter?data=[out:json];node["generator:source"="solar"]["location"="roof"]',
    '(newer:"',
    'Z")',
    '(49.92,-10.6,61.02,1.935);out;'
  ];
  static const _limitNumber = 1000;
  static const Duration _updateTime = Duration(days: 1);

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    // await _updateDatabase();
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
    await createUserBadgesTable(db);
    // await createOsmTables(db);
    await createUserPanelsTable(db);
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
        "lon FLOAT"
        ")");
  }

  Future<void> createUserBadgesTable(Database db) async {
    await db.execute("CREATE TABLE $_userBadgeTableName("
        "id INTEGER PRIMARY KEY,"
        "imagePath TEXT,"
        "unlocked INTEGER,"
        "dateUnlocked TEXT,"
        "description TEXT"
        ")");
    Future.forEach(initialBadges, (badgeRow) async {
      await db.insert(_userBadgeTableName, badgeRow.toMap());
    });
  }

  Future<void> createOsmTables(Database db) async {
    final Future<List<SolarPanel>> futurePanelData = _getOSMPanelData();
    db.execute("CREATE TABLE $_osmPanelTableName("
        "id INTEGER PRIMARY KEY,"
        "lat FLOAT,"
        "lon FLOAT"
        ")");
    Batch batch = db.batch();
    List<SolarPanel> panelData = await futurePanelData;
    for (int i = 0; i < panelData.length; i++) {
      batch.insert(_osmPanelTableName, panelData[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (i % 100000 == 0) {
        print(i);
        await batch.commit(noResult: true);
      }
    }
    await batch.commit(noResult: true);
    db.execute("CREATE TABLE $_dbLastUpdated("
        "id INT PRIMARY KEY,"
        "last_updated BIGINT"
        ")");
    await _updateDatabaseLastModified(db);
  }

  Future<void> _updateDatabaseLastModified(Database db) async {
    final Map<String, dynamic> lastModified = {
      'id': 1,
      'last_updated': DateTime.now().millisecondsSinceEpoch
    };
    await db.insert(
      _dbLastUpdated,
      lastModified,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SolarPanel>> getOSMPanelData(LatLngBounds bounds) async {
    final Database db = await database;
    final double minLat = bounds.southwest.latitude;
    final double maxLat = bounds.northeast.latitude;
    final double minLng = bounds.southwest.longitude;
    final double maxLng = bounds.northeast.longitude;
    final List<Map<String, dynamic>> response = await db.rawQuery(
        "SELECT * FROM $_osmPanelTableName WHERE lat>$minLat AND lat<$maxLat AND lon>$minLng AND lon<$maxLng LIMIT $_limitNumber");
    List<SolarPanel> panelData =
        response.map((row) => SolarPanel.fromMap(row)).toList();
    return panelData;
  }

  Future<List<SolarPanel>> getAllOSMPanelData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> response =
        await db.rawQuery("SELECT * FROM $_osmPanelTableName");
    List<SolarPanel> panelData =
        response.map((row) => SolarPanel.fromMap(row)).toList();
    return panelData;
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
    if (count >= maxPanels) {
      return (count - maxPanels);
    } else {
      return count;
    }
  }

  Future<int> getUploadQueueCount() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT COUNT (*) FROM $_uploadQueueTableName");
    int count = Sqflite.firstIntValue(result);
    if (count >= maxPanels) {
      return (count - maxPanels);
    } else {
      return count;
    }
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

  Future<void> insertQueueData(String imagePath, LatLng panelLocation) async {
    final Database db = await database;
    final toUpload = UploadQueueItem(
        path: imagePath,
        lat: panelLocation.latitude,
        lon: panelLocation.longitude);
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
      // Use a `where` clause to delete a specific dog.
      where: "path = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [path],
    );
  }

  Future<void> _updateDatabase() async {
    final Database db = await database;
    final List<Map<String, dynamic>> query = await db.query(_dbLastUpdated);
    final DateTime lastUpdated =
        DateTime.fromMillisecondsSinceEpoch(query[0]['last_updated']);
    final Duration timeSinceLastUpdate = DateTime.now().difference(lastUpdated);
    if (timeSinceLastUpdate > _updateTime) {
      final Map<int, SolarPanel> newPanelData =
          await _getPanelDataFromTime(lastUpdated);
      Batch batch = db.batch();
      for (int i = 0; i < newPanelData.length; i++) {
        batch.insert(_osmPanelTableName, newPanelData[i].toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        if (i % 100000 == 0) {
          await batch.commit(noResult: true);
        }
      }
      await batch.commit(noResult: true);
      await _updateDatabaseLastModified(db);
    }
  }

  Future<Map<int, SolarPanel>> _getPanelDataFromTime(
      DateTime lastUpdated) async {
    final String url = _osmBaseURL[0] +
        _osmBaseURL[1] +
        lastUpdated.toIso8601String() +
        _osmBaseURL[2] +
        _osmBaseURL[3];
    final response = await http.get(url);
    final responseData = jsonDecode(response.body)['elements'];
    final Map<int, SolarPanel> panelData = {};
    responseData
        .map((panel) => SolarPanel.fromMap(panel))
        .forEach((solarPanel) => panelData[solarPanel.id] = solarPanel);
    return panelData;
  }

  Future<List<SolarPanel>> _getOSMPanelData() async {
    final String url = _osmBaseURL[0] + _osmBaseURL[3];
    final response = await http.get(url);
    final responseData = jsonDecode(response.body)['elements'];
    final List<SolarPanel> panelData = [];
    responseData
        .map((panel) => SolarPanel.fromMap(panel))
        .forEach((solarPanel) => panelData.add(solarPanel));
    return panelData;
  }

  Future<List<Badge>> checkForNewBadges(SolarPanel lastUploadedPanel) async {
    // Checks the badge table to see whether any new badges have been earned
    // Updates the table accordingly
    final Database db = await database;
    List<Badge> currentBadges = await getUserBadgeData();
    List<SolarPanel> currentPanels = await getUserPanelData();
    int panelCount = await getUserPanelCount();
    List<Badge> newBadges = new List();

    unlockBadgeOfIndex(int index, List<Badge> badgeList) async {
      Badge unlockedBadge = currentBadges[index];
      unlockedBadge.unlocked = true;
      unlockedBadge.dateUnlocked = DateTime.now();
      badgeList.add(unlockedBadge);
      await db.insert(_userBadgeTableName, unlockedBadge.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    checkLevelBadges() {
      // Check level badges (rows 0-2 in badge table)
      List<int> levels = [1, 5, 10];
      for (int i = 0; i < levels.length; i++) {
        if ((panelCount >= levelToPanels[levels[i]]) &&
            !currentBadges[i].unlocked) {
          unlockBadgeOfIndex(i, newBadges);
        }
      }
    }

    checkPanelCountBadges() {
      // Check panel count badges (rows 3-5 in badge table)
      List<int> badgePanelCounts = [5, 20, 50];
      for (int i = 0; i < badgePanelCounts.length; i++) {
        if ((panelCount >= badgePanelCounts[i]) &&
            !currentBadges[i + 3].unlocked) {
          unlockBadgeOfIndex(i + 3, newBadges);
        }
      }
    }

    checkExplorerBadge() async {
      // Check explorer badge (row 7 in badge table)
      double distance;
      for (int i = 0; i < currentPanels.length; i++) {
        try {
          distance = await FlutterLocationsDistance().distanceBetween(
              lastUploadedPanel.lat,
              lastUploadedPanel.lon,
              currentPanels[i].lat,
              currentPanels[i].lon);
        } on Exception {
          distance = -1.0;
        }
        if ((distance >= 321868.8) && !currentBadges[7].unlocked) {
          unlockBadgeOfIndex(7, newBadges);
        }
      }
    }

    //TODO: implement streak badge
    // will require changing tables for user panels to include datetime

    checkLevelBadges();
    checkPanelCountBadges();
    checkExplorerBadge();

    return newBadges;
  }
}
