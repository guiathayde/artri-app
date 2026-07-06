import 'dart:convert';

import 'package:artriapp/models/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:http/http.dart' as http;

class CustomExercisesService {
  final String _baseUrl = Environment.apiUrl;

  Future<List<Training>> _getTrainings() async {
    final response = await http.get(Uri.parse('$_baseUrl/trainings'));
    return List<Training>.from(
      jsonDecode(response.body).map((training) => Training.fromJson(training)),
    );
  }

  Future<List<Exercise>> _getExercises() async {
    final response = await http.get(Uri.parse('$_baseUrl/exercises'));
    return List<Exercise>.from(
      jsonDecode(response.body).map((exercise) => Exercise.fromJson(exercise)),
    );
  }

  Future<Map<String, List<Exercise>>> loadCatalog(
    ExerciseDifficulty difficulty,
    List<CustomExerciseGroup> groups,
  ) async {
    final trainings = await _getTrainings();
    final exercises = await _getExercises();
    final exerciseById = {for (final e in exercises) e.id: e};

    final result = <String, List<Exercise>>{};
    for (final group in groups) {
      final name = group.trainingName(difficulty);
      final matches = trainings.where((t) => t.name == name);
      final training = matches.isEmpty ? null : matches.first;

      result[group.key] = training == null
          ? <Exercise>[]
          : [
              for (final id in training.exercises)
                if (exerciseById.containsKey(id)) exerciseById[id]!,
            ];
    }
    return result;
  }
}
