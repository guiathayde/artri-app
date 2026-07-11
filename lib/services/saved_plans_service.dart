import 'package:artriapp/database/index.dart';
import 'package:artriapp/models/index.dart';
import 'package:artriapp/utils/enums/index.dart';

class SavedPlansService {
  final AppDatabase _database;

  SavedPlansService(this._database);

  SavedPlanDao get _dao => _database.savedPlanDao;

  Future<List<SavedPlan>> getAll() async {
    final plans = await _dao.findAllPlans();
    final result = <SavedPlan>[];
    for (final plan in plans) {
      final exercises = await _dao.findExercisesForPlan(plan.id!);
      result.add(_toDomain(plan, exercises));
    }
    return result;
  }

  Future<int> create(SavedPlan plan) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final entity = SavedPlanEntity(
      name: plan.name,
      difficulty: plan.difficulty.toString(),
      createdAt: now,
      updatedAt: now,
    );
    return _dao.createPlan(entity, _toExerciseEntities(plan.exercises));
  }

  Future<void> update(SavedPlan plan) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final entity = SavedPlanEntity(
      id: plan.id,
      name: plan.name,
      difficulty: plan.difficulty.toString(),
      createdAt: plan.createdAt?.millisecondsSinceEpoch ?? now,
      updatedAt: now,
    );
    return _dao.updatePlan(entity, _toExerciseEntities(plan.exercises));
  }

  Future<void> delete(int id) => _dao.deletePlanCascade(id);

  List<SavedPlanExerciseEntity> _toExerciseEntities(List<Exercise> exercises) {
    return [
      for (var i = 0; i < exercises.length; i++)
        SavedPlanExerciseEntity(
          planId: 0, // será preenchido dentro da transação com o ID do plano
          position: i,
          exerciseId: exercises[i].id,
          name: exercises[i].name,
          description: exercises[i].description,
          tutorialLink: exercises[i].tutorialLink,
          difficulty: exercises[i].difficulty.toString(),
          sets: exercises[i].details.sets,
          reps: exercises[i].details.reps,
          duration: exercises[i].details.duration,
          rest: exercises[i].details.rest,
        ),
    ];
  }

  SavedPlan _toDomain(
    SavedPlanEntity plan,
    List<SavedPlanExerciseEntity> exercises,
  ) {
    return SavedPlan(
      id: plan.id,
      name: plan.name,
      difficulty: ExerciseDifficulty.fromString(plan.difficulty),
      createdAt: DateTime.fromMillisecondsSinceEpoch(plan.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(plan.updatedAt),
      exercises: [
        for (final e in exercises)
          Exercise(
            id: e.exerciseId,
            name: e.name,
            description: e.description,
            tutorialLink: e.tutorialLink,
            difficulty: ExerciseDifficulty.fromString(e.difficulty),
            details: ExerciseDetails(
              sets: e.sets,
              reps: e.reps,
              duration: e.duration,
              rest: e.rest,
            ),
          ),
      ],
    );
  }
}
