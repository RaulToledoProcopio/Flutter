// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TareaDao? _tareaDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tarea` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `isCompleted` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TareaDao get tareaDao {
    return _tareaDaoInstance ??= _$TareaDao(database, changeListener);
  }
}

class _$TareaDao extends TareaDao {
  _$TareaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tareaInsertionAdapter = InsertionAdapter(
            database,
            'Tarea',
            (Tarea item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'isCompleted': item.isCompleted ? 1 : 0
                }),
        _tareaUpdateAdapter = UpdateAdapter(
            database,
            'Tarea',
            ['id'],
            (Tarea item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'isCompleted': item.isCompleted ? 1 : 0
                }),
        _tareaDeletionAdapter = DeletionAdapter(
            database,
            'Tarea',
            ['id'],
            (Tarea item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'isCompleted': item.isCompleted ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tarea> _tareaInsertionAdapter;

  final UpdateAdapter<Tarea> _tareaUpdateAdapter;

  final DeletionAdapter<Tarea> _tareaDeletionAdapter;

  @override
  Future<List<Tarea>> getAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM Tarea ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => Tarea(
            id: row['id'] as int?,
            title: row['title'] as String,
            isCompleted: (row['isCompleted'] as int) != 0));
  }

  @override
  Future<void> insertTask(Tarea task) async {
    await _tareaInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTask(Tarea task) async {
    await _tareaUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(Tarea task) async {
    await _tareaDeletionAdapter.delete(task);
  }
}
