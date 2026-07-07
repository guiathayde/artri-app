import 'dart:developer';

import 'package:artriapp/models/index.dart';
import 'package:artriapp/services/custom_exercises_service.dart';
import 'package:artriapp/utils/custom_exercise_categories.dart';
import 'package:artriapp/utils/enums/index.dart';
import 'package:flutter/material.dart';

class CustomExercisesViewModel extends ChangeNotifier {
  final CustomExercisesService _service;

  CustomExercisesViewModel(this._service);

  final List<CustomExerciseStep> steps = kCustomExerciseSteps;

  ExerciseDifficulty? _difficulty;
  ExerciseDifficulty? get difficulty => _difficulty;

  SavedPlan? _editingPlan;
  SavedPlan? get editingPlan => _editingPlan;
  bool get isEditing => _editingPlan != null;

  final Map<String, List<Exercise>> _catalog = {};

  final Map<String, List<int>> _selected = {};

  int _stepIndex = 0;
  int get stepIndex => _stepIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _loadError;
  String? get loadError => _loadError;

  CustomExerciseStep get currentStep => steps[_stepIndex];
  int get stepCount => steps.length;
  bool get isLastStep => _stepIndex == steps.length - 1;

  Future<void> start(ExerciseDifficulty difficulty) async {
    _editingPlan = null;
    _difficulty = difficulty;
    _stepIndex = 0;
    _selected.clear();
    _catalog.clear();
    _loadError = null;
    _isLoading = true;
    notifyListeners();

    try {
      final groups = [for (final s in steps) ...s.groups];
      final catalog = await _service.loadCatalog(difficulty, groups);
      _catalog.addAll(catalog);
    } catch (e) {
      log('Erro ao carregar catálogo personalizado: $e');
      _loadError = 'Não foi possível carregar os exercícios. Tente novamente.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startForEdit(SavedPlan plan) async {
    _editingPlan = plan;
    _difficulty = plan.difficulty;
    _stepIndex = 0;
    _selected.clear();
    _catalog.clear();
    _loadError = null;
    _isLoading = true;
    notifyListeners();

    try {
      final groups = [for (final s in steps) ...s.groups];
      final catalog = await _service.loadCatalog(plan.difficulty, groups);
      _catalog.addAll(catalog);
      _preselectFromPlan(plan);
    } catch (e) {
      log('Erro ao carregar catálogo para edição: $e');
      _loadError = 'Não foi possível carregar os exercícios. Tente novamente.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _preselectFromPlan(SavedPlan plan) {
    for (final exercise in plan.exercises) {
      for (final step in steps) {
        var matched = false;
        for (final group in step.groups) {
          final catalog = _catalog[group.key] ?? const <Exercise>[];
          if (catalog.any((c) => c.id == exercise.id)) {
            final selected = _selected.putIfAbsent(group.key, () => []);
            if (!selected.contains(exercise.id)) selected.add(exercise.id);
            matched = true;
            break;
          }
        }
        if (matched) break;
      }
    }
  }

  List<Exercise> catalogFor(String groupKey) => _catalog[groupKey] ?? const [];

  bool isSelected(String groupKey, int exerciseId) =>
      _selected[groupKey]?.contains(exerciseId) ?? false;

  int selectedCount(String groupKey) => _selected[groupKey]?.length ?? 0;

  void toggle(CustomExerciseGroup group, int exerciseId) {
    final current = _selected.putIfAbsent(group.key, () => []);
    if (current.contains(exerciseId)) {
      current.remove(exerciseId);
    } else {
      if (current.length >= group.requiredCount(_difficulty!)) return;
      current.add(exerciseId);
    }
    notifyListeners();
  }

  bool isGroupComplete(CustomExerciseGroup group) =>
      selectedCount(group.key) == group.requiredCount(_difficulty!);

  bool isStepComplete(CustomExerciseStep step) =>
      step.groups.every(isGroupComplete);

  bool get isCurrentStepComplete => isStepComplete(currentStep);

  bool get isPlanComplete => steps.every(isStepComplete);

  void next() {
    if (!isLastStep) {
      _stepIndex++;
      notifyListeners();
    }
  }

  void back() {
    if (_stepIndex > 0) {
      _stepIndex--;
      notifyListeners();
    }
  }

  void goToStep(int index) {
    if (index >= 0 && index < steps.length) {
      _stepIndex = index;
      notifyListeners();
    }
  }

  List<Exercise> orderedSelection() {
    final result = <Exercise>[];
    for (final step in steps) {
      for (final group in step.groups) {
        final selectedIds = _selected[group.key] ?? const [];
        final available = catalogFor(group.key);
        for (final exercise in available) {
          if (selectedIds.contains(exercise.id)) result.add(exercise);
        }
      }
    }
    return result;
  }
}
