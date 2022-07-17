import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity.dart';

class ActivityDbHelper {
  ActivityDbHelper._privateConstructor();

  static final ActivityDbHelper instance =
      ActivityDbHelper._privateConstructor();

  static Database? _database;

  static const String tableA = 'activities';
  static const String tableAId = 'activity_id';
  static const String tableAName = 'activity_name';

  static const String tableD = 'dates';
  static const String tableDId = 'date_id';
  static const String tableDDate = 'date_date';
  static const String tableDForeign = 'date_activity';

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activities.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableA(
        $tableAId INTEGER PRIMARY KEY,
        $tableAName TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableD(
        $tableDId INTEGER PRIMARY KEY,
        $tableDDate TEXT,
        $tableDForeign INTEGER,
        FOREIGN KEY ($tableDForeign) REFERENCES $tableA($tableAId) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> addActivity(Activity activity) async {
    Database db = await instance.database;
    return await db.insert(
      tableA,
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableA, where: 'id = ?', whereArgs: [id]);
  }

  Future<Activity> getOneActivity(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> map = await db.query("""
      SELECT * FROM $tableA WHERE $tableAId = $id;
    """);
    final Activity activity = Activity(id: map.first[tableAId], name: map.first[tableAName]);
    return activity;
  }

  Future<List<Activity>> getActivities() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableA);

    return List.generate(maps.length, (i) {
      return Activity(
        id: maps[i][tableAId],
        name: maps[i][tableAName],
      );
    });
  }

// Future<int> update(Activity activity) async {
//   Database db = await instance.database;
//   return await db.update(table, note.toMap(),
//       where: 'id = ?', whereArgs: [note.id]);
// } //TODO: figure out how to implement this without breaking everything

}
