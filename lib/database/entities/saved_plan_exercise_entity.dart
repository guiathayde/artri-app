import 'package:floor/floor.dart';

import 'saved_plan_entity.dart';

@Entity(
  tableName: 'SavedPlanExerciseEntity',
  foreignKeys: [
    ForeignKey(
      childColumns: ['planId'],
      parentColumns: ['id'],
      entity: SavedPlanEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [Index(value: ['planId'])],
)
class SavedPlanExerciseEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  int planId; // ID de referência do plano
  final int exerciseId; // ID do backend

  final int position; // Ordem de execução do exercício
  final String name;
  final String description;
  final String tutorialLink;
  final String difficulty; // 'easy' | 'medium' | 'hard'

  /// Campos do ExerciseDetails
  final int sets;
  final int? reps;
  final int? duration;
  final int? rest;

  SavedPlanExerciseEntity({
    this.id,
    required this.planId,
    required this.position,
    required this.exerciseId,
    required this.name,
    required this.description,
    required this.tutorialLink,
    required this.difficulty,
    required this.sets,
    this.reps,
    this.duration,
    this.rest,
  });
}
