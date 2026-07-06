import 'package:artriapp/utils/enums/exercise_difficulty.dart';

String difficultyLevelSuffix(ExerciseDifficulty difficulty) {
  switch (difficulty) {
    case ExerciseDifficulty.easy:
      return 'INICIANTE';
    case ExerciseDifficulty.medium:
      return 'INTERMEDIÁRIO';
    case ExerciseDifficulty.hard:
      return 'AVANÇADO';
  }
}

class CustomExerciseGroup {
  final String
      key; // Grupo (ex.: 'mob_pernas') para mapear os exercícios carregados do backend

  final String
      promptSuffix; // ex.: "de mobilidade para perna", "para as pernas"

  final String
      trainingNameBase; // Training no backend (ex.: "MOBILIDADE PERNAS")

  final Map<ExerciseDifficulty, int> _requiredByLevel;

  const CustomExerciseGroup({
    required this.key,
    required this.promptSuffix,
    required this.trainingNameBase,
    required Map<ExerciseDifficulty, int> requiredByLevel,
  }) : _requiredByLevel = requiredByLevel;

  int requiredCount(ExerciseDifficulty difficulty) =>
      _requiredByLevel[difficulty] ?? 0;

  String trainingName(ExerciseDifficulty difficulty) =>
      '$trainingNameBase - ${difficultyLevelSuffix(difficulty)}';

  String prompt(ExerciseDifficulty difficulty) {
    final n = requiredCount(difficulty);
    final word = n == 1 ? 'exercício' : 'exercícios';
    return 'Selecione $n $word $promptSuffix das opções abaixo:';
  }
}

class CustomExerciseStep {
  final String title;

  final String overviewSuffix;

  final List<CustomExerciseGroup> groups;

  const CustomExerciseStep({
    required this.title,
    required this.overviewSuffix,
    required this.groups,
  });

  int totalRequired(ExerciseDifficulty difficulty) =>
      groups.fold(0, (sum, g) => sum + g.requiredCount(difficulty));
}

const List<CustomExerciseStep> kCustomExerciseSteps = [
  CustomExerciseStep(
    title: 'Mobilidade',
    overviewSuffix: 'de mobilidade',
    groups: [
      CustomExerciseGroup(
        key: 'mob_pernas',
        promptSuffix: 'de mobilidade para perna',
        trainingNameBase: 'MOBILIDADE PERNAS',
        requiredByLevel: {
          ExerciseDifficulty.easy: 2,
          ExerciseDifficulty.medium: 2,
          ExerciseDifficulty.hard: 1,
        },
      ),
      CustomExerciseGroup(
        key: 'mob_bracos',
        promptSuffix: 'de mobilidade para os braços',
        trainingNameBase: 'MOBILIDADE BRAÇOS',
        requiredByLevel: {
          ExerciseDifficulty.easy: 2,
          ExerciseDifficulty.medium: 2,
          ExerciseDifficulty.hard: 1,
        },
      ),
      CustomExerciseGroup(
        key: 'mob_tronco',
        promptSuffix: 'de mobilidade para o tronco',
        trainingNameBase: 'MOBILIDADE TRONCO',
        requiredByLevel: {
          ExerciseDifficulty.easy: 1,
          ExerciseDifficulty.medium: 1,
          ExerciseDifficulty.hard: 1,
        },
      ),
    ],
  ),
  CustomExerciseStep(
    title: 'Aquecimento',
    overviewSuffix: 'de aquecimento',
    groups: [
      CustomExerciseGroup(
        key: 'aerobico',
        promptSuffix: 'de aquecimento',
        trainingNameBase: 'AERÓBICO',
        requiredByLevel: {
          ExerciseDifficulty.easy: 2,
          ExerciseDifficulty.medium: 3,
          ExerciseDifficulty.hard: 3,
        },
      ),
    ],
  ),
  CustomExerciseStep(
    title: 'Pernas',
    overviewSuffix: 'para as pernas',
    groups: [
      CustomExerciseGroup(
        key: 'inferior',
        promptSuffix: 'para as pernas',
        trainingNameBase: 'FORTALECIMENTO MEMBRO INFERIOR',
        requiredByLevel: {
          ExerciseDifficulty.easy: 2,
          ExerciseDifficulty.medium: 3,
          ExerciseDifficulty.hard: 3,
        },
      ),
    ],
  ),
  CustomExerciseStep(
    title: 'Braços',
    overviewSuffix: 'para os braços',
    groups: [
      CustomExerciseGroup(
        key: 'superior',
        promptSuffix: 'para os braços',
        trainingNameBase: 'FORTALECIMENTO MEMBRO SUPERIOR',
        requiredByLevel: {
          ExerciseDifficulty.easy: 2,
          ExerciseDifficulty.medium: 3,
          ExerciseDifficulty.hard: 3,
        },
      ),
    ],
  ),
  CustomExerciseStep(
    title: 'Tronco',
    overviewSuffix: 'para o tronco',
    groups: [
      CustomExerciseGroup(
        key: 'core',
        promptSuffix: 'para o tronco',
        trainingNameBase: 'FORTALECIMENTO CORE',
        requiredByLevel: {
          ExerciseDifficulty.easy: 1,
          ExerciseDifficulty.medium: 1,
          ExerciseDifficulty.hard: 2,
        },
      ),
    ],
  ),
  CustomExerciseStep(
    title: 'Alongamento',
    overviewSuffix: 'de alongamento',
    groups: [
      CustomExerciseGroup(
        key: 'alongamento',
        promptSuffix: 'de alongamento',
        trainingNameBase: 'ALONGAMENTO',
        requiredByLevel: {
          ExerciseDifficulty.easy: 3,
          ExerciseDifficulty.medium: 3,
          ExerciseDifficulty.hard: 3,
        },
      ),
    ],
  ),
];
