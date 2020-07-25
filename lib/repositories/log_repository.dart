import 'dart:developer';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stopwatchdemo/database/database.dart';
import 'package:stopwatchdemo/model/log_model.dart';
import 'package:stopwatchdemo/repositories/interfaces/log_interface.dart';

/// 日光浴履歴リポジトリ
class LogRepository extends Disposable implements ILogRepository {
  static final _table = 'logs';
  static Future<Database> _database;

  LogRepository() {
    _database = DatabaseHelper.instance.database;
  }

  /// [HistoryModel] を新たに登録し、登録されたidを返します。
  /// 失敗した場合はnullを返します。
  Future<int> insert(LogModel row) async {
    final Database db = await _database;
    try {
      return await db.insert(_table, row.toMap());
    } catch (error) {
      print(error);
    }
    return null;
  }

  /// [HistoryModel] をもとにレコードを更新し、idを返します。
  /// 失敗した場合はnullを返します。
  Future<int> update(LogModel row) async {
    final Database db = await _database;
    try {
      log(row.toMap().toString());
      return await db.update(_table, row.toMap(), where: 'id = ?', whereArgs: [row.id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  /// [id] をもつレコードを削除し、idを返します。
  /// 失敗した場合はnullを返します。
  Future<int> delete(int id) async {
    final Database db = await _database;
    try {
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  /// [id] をもつレコードを1件返します。
  /// 見つからない場合はnullを返します。
  Future<LogModel> findById(int id) async {
    final Database db = await _database;
    try {
      List<Map<String, dynamic>> maps = await db.query(
        _table,
        columns: ['id', 'start_dt', 'end_dt'],
        where: 'id = ?',
        whereArgs: [id]
      );

      if (maps.length > 0) {
        return LogModel.fromMap(maps.first);
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  /// 指定された期間 [from] から [to] までのレコードリストを返却します。
  /// 見つからない場合は空配列を返します。
  Future<List<LogModel>> findByDateRange(DateTime from, DateTime to) async {
    final Database db = await _database;
    try {
      List<Map<String, dynamic>> maps = await db.query(
        _table,
        columns: ['id', 'start_dt', 'end_dt'],
        where: 'start_dt >= ? AND end_dt <= ?',
        whereArgs: [from.toUtc().toString(), to.toUtc().toString()]
      );

      List<LogModel> list = [];
      maps.forEach((element) {
        list.add(LogModel.fromMap(element));
      });
      return list;
    } catch (error) {
      print(error);
    }
    return [];
  }

  /// 全件取得します。
  /// 見つからない場合は空配列を返します。
  Future<List<LogModel>> findAll() async {
    final Database db = await _database;
    // debug: db.delete(_table);
    try {
      List<Map<String, dynamic>> maps = await db.query(
        _table,
        columns: ['id', 'start_dt', 'end_dt']
      );
      List<LogModel> list = [];
      maps.forEach((element) {
        list.add(LogModel.fromMap(element));
      });

      return list;
    } catch (error) {
      print(error);
    }
    return [];
  }

  @override
  void dispose() {}
}
