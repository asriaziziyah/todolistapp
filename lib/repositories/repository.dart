import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_todolistv2/repositories/database_connection.dart';


class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database = null;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _databaseConnection.setDatabase();
    return _database!;
  }

  InsertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async{
    var connection = await database;
    return await connection.query(table);
  }

  readDatabyId(table, itemId) async{
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async{
    var connection = await database;
    return await connection.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteData(table, itemId) async{
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");

  }

  readDataByColumnName(table, columnName, columnValue) async{
    var connection = await database;
    return await connection.query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }
}
