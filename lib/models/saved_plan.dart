import 'package:artriapp/models/api_responses/index.dart';
import 'package:artriapp/utils/enums/exercise_difficulty.dart';

class SavedPlan {
  final int? id;
  final String name;
  final ExerciseDifficulty difficulty;
  final List<Exercise> exercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SavedPlan({
    this.id,
    required this.name,
    required this.difficulty,
    required this.exercises,
    this.createdAt,
    this.updatedAt,
  });

  int get exerciseCount => exercises.length;

  SavedPlan copyWith({
    String? name,
    ExerciseDifficulty? difficulty,
    List<Exercise>? exercises,
  }) {
    return SavedPlan(
      id: id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
