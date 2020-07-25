import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();

    return _database;
  }

  static Future _initDatabase() async {
    try {
      final String databasePath = await getDatabasesPath();
      final String path = databasePath + '/stopwatch.db';
      log("database: $path");
      var database = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade, onConfigure: _onConfigure);
      return database;
    } catch (error) {
      log(error);
    }
  }

  static void _onCreate(final Database database, final int newVersion) async {
    final List<String> sqlList = (await rootBundle.loadString('assets/sql/create.sql')).split(';');

    Future.forEach(sqlList, (sql) async {
      log(sql);
      if (sql != '') {
        await database.execute(sql);
      }
    });
  }

  static Future<FutureOr<void>> _onUpgrade (final Database database, final int oldVersion, int newVersion) async {
    log("upgrade database: $oldVersion to $newVersion");
    // do something. database.execute('alter table ...')
  }

  static void _onConfigure(final Database database) async {
    // await database.execute('PRAGMA foreign_keys = ON');
  }
}