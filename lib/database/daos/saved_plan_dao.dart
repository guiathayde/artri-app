import 'package:floor/floor.dart';

import '../entities/saved_plan_entity.dart';
import '../entities/saved_plan_exercise_entity.dart';

@dao
abstract class SavedPlanDao {
  @Query('SELECT * FROM SavedPlanEntity ORDER BY updatedAt DESC')
  Future<List<SavedPlanEntity>> findAllPlans();

  @Query('SELECT * FROM SavedPlanEntity WHERE id = :id')
  Future<SavedPlanEntity?> findPlanById(int id);

  @Query(
    'SELECT * FROM SavedPlanExerciseEntity WHERE planId = :planId '
    'ORDER BY position ASC',
  )
  Future<List<SavedPlanExerciseEntity>> findExercisesForPlan(int planId);

  @insert
  Future<int> insertPlan(SavedPlanEntity plan);

  @insert
  Future<void> insertExercises(List<SavedPlanExerciseEntity> exercises);

  @update
  Future<void> updatePlanRow(SavedPlanEntity plan);

  @Query('DELETE FROM SavedPlanExerciseEntity WHERE planId = :planId')
  Future<void> deleteExercisesForPlan(int planId);

  @Query('DELETE FROM SavedPlanEntity WHERE id = :id')
  Future<void> deletePlanById(int id);

  @transaction
  Future<int> createPlan(
    SavedPlanEntity plan,
    List<SavedPlanExerciseEntity> exercises,
  ) async {
    final planId = await insertPlan(plan);
    for (final exercise in exercises) {
      exercise.planId = planId;
    }
    await insertExercises(exercises);
    return planId;
  }

  @transaction
  Future<void> updatePlan(
    SavedPlanEntity plan,
    List<SavedPlanExerciseEntity> exercises,
  ) async {
    await updatePlanRow(plan);
    await deleteExercisesForPlan(plan.id!);
    for (final exercise in exercises) {
      exercise.planId = plan.id!;
    }
    await insertExercises(exercises);
  }

  @transaction
  Future<void> deletePlanCascade(int id) async {
    await deleteExercisesForPlan(id);
    await deletePlanById(id);
  }
}
