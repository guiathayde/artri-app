import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/saved_plan_dao.dart';
import 'entities/saved_plan_entity.dart';
import 'entities/saved_plan_exercise_entity.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [SavedPlanEntity, SavedPlanExerciseEntity],
)
abstract class AppDatabase extends FloorDatabase {
  SavedPlanDao get savedPlanDao;
}
