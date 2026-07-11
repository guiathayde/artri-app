import 'package:floor/floor.dart';

@entity
class SavedPlanEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String difficulty; // 'easy' | 'medium' | 'hard' (ExerciseDifficulty)

  final int createdAt;
  final int updatedAt;

  const SavedPlanEntity({
    this.id,
    required this.name,
    required this.difficulty,
    required this.createdAt,
    required this.updatedAt,
  });
}
