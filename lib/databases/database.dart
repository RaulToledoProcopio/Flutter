import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'tarea.dart';
import 'tareaDao.dart';

part 'database.g.dart';

// Definimos la base de datos con versión y entidades.
@Database(version: 1, entities: [Tarea])
abstract class AppDatabase extends FloorDatabase {
  TareaDao get tareaDao;
}
