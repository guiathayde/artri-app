// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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

  SavedPlanDao? _savedPlanDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `SavedPlanEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `difficulty` TEXT NOT NULL, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SavedPlanExerciseEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `planId` INTEGER NOT NULL, `position` INTEGER NOT NULL, `exerciseId` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `tutorialLink` TEXT NOT NULL, `difficulty` TEXT NOT NULL, `sets` INTEGER NOT NULL, `reps` INTEGER, `duration` INTEGER, `rest` INTEGER, FOREIGN KEY (`planId`) REFERENCES `SavedPlanEntity` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE INDEX `index_SavedPlanExerciseEntity_planId` ON `SavedPlanExerciseEntity` (`planId`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SavedPlanDao get savedPlanDao {
    return _savedPlanDaoInstance ??= _$SavedPlanDao(database, changeListener);
  }
}

class _$SavedPlanDao extends SavedPlanDao {
  _$SavedPlanDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _savedPlanEntityInsertionAdapter = InsertionAdapter(
            database,
            'SavedPlanEntity',
            (SavedPlanEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'difficulty': item.difficulty,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _savedPlanExerciseEntityInsertionAdapter = InsertionAdapter(
            database,
            'SavedPlanExerciseEntity',
            (SavedPlanExerciseEntity item) => <String, Object?>{
                  'id': item.id,
                  'planId': item.planId,
                  'position': item.position,
                  'exerciseId': item.exerciseId,
                  'name': item.name,
                  'description': item.description,
                  'tutorialLink': item.tutorialLink,
                  'difficulty': item.difficulty,
                  'sets': item.sets,
                  'reps': item.reps,
                  'duration': item.duration,
                  'rest': item.rest
                }),
        _savedPlanEntityUpdateAdapter = UpdateAdapter(
            database,
            'SavedPlanEntity',
            ['id'],
            (SavedPlanEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'difficulty': item.difficulty,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SavedPlanEntity> _savedPlanEntityInsertionAdapter;

  final InsertionAdapter<SavedPlanExerciseEntity>
      _savedPlanExerciseEntityInsertionAdapter;

  final UpdateAdapter<SavedPlanEntity> _savedPlanEntityUpdateAdapter;

  @override
  Future<List<SavedPlanEntity>> findAllPlans() async {
    return _queryAdapter.queryList(
        'SELECT * FROM SavedPlanEntity ORDER BY updatedAt DESC',
        mapper: (Map<String, Object?> row) => SavedPlanEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            difficulty: row['difficulty'] as String,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int));
  }

  @override
  Future<SavedPlanEntity?> findPlanById(int id) async {
    return _queryAdapter.query('SELECT * FROM SavedPlanEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SavedPlanEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            difficulty: row['difficulty'] as String,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int),
        arguments: [id]);
  }

  @override
  Future<List<SavedPlanExerciseEntity>> findExercisesForPlan(int planId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SavedPlanExerciseEntity WHERE planId = ?1 ORDER BY position ASC',
        mapper: (Map<String, Object?> row) => SavedPlanExerciseEntity(id: row['id'] as int?, planId: row['planId'] as int, position: row['position'] as int, exerciseId: row['exerciseId'] as int, name: row['name'] as String, description: row['description'] as String, tutorialLink: row['tutorialLink'] as String, difficulty: row['difficulty'] as String, sets: row['sets'] as int, reps: row['reps'] as int?, duration: row['duration'] as int?, rest: row['rest'] as int?),
        arguments: [planId]);
  }

  @override
  Future<void> deleteExercisesForPlan(int planId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM SavedPlanExerciseEntity WHERE planId = ?1',
        arguments: [planId]);
  }

  @override
  Future<void> deletePlanById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM SavedPlanEntity WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertPlan(SavedPlanEntity plan) {
    return _savedPlanEntityInsertionAdapter.insertAndReturnId(
        plan, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertExercises(List<SavedPlanExerciseEntity> exercises) async {
    await _savedPlanExerciseEntityInsertionAdapter.insertList(
        exercises, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePlanRow(SavedPlanEntity plan) async {
    await _savedPlanEntityUpdateAdapter.update(plan, OnConflictStrategy.abort);
  }

  @override
  Future<int> createPlan(
    SavedPlanEntity plan,
    List<SavedPlanExerciseEntity> exercises,
  ) async {
    if (database is sqflite.Transaction) {
      return super.createPlan(plan, exercises);
    } else {
      return (database as sqflite.Database)
          .transaction<int>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        return transactionDatabase.savedPlanDao.createPlan(plan, exercises);
      });
    }
  }

  @override
  Future<void> updatePlan(
    SavedPlanEntity plan,
    List<SavedPlanExerciseEntity> exercises,
  ) async {
    if (database is sqflite.Transaction) {
      await super.updatePlan(plan, exercises);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.savedPlanDao.updatePlan(plan, exercises);
      });
    }
  }

  @override
  Future<void> deletePlanCascade(int id) async {
    if (database is sqflite.Transaction) {
      await super.deletePlanCascade(id);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.savedPlanDao.deletePlanCascade(id);
      });
    }
  }
}
