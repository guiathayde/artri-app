import 'dart:developer';

import 'package:artriapp/models/index.dart';
import 'package:artriapp/services/saved_plans_service.dart';
import 'package:artriapp/utils/enums/index.dart';
import 'package:flutter/material.dart';

class SavedPlansViewModel extends ChangeNotifier {
  final SavedPlansService _service;

  SavedPlansViewModel(this._service);

  List<SavedPlan> _plans = [];
  List<SavedPlan> get plans => _plans;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get isEmpty => !_isLoading && _error == null && _plans.isEmpty;

  Future<void> loadPlans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plans = await _service.getAll();
    } catch (e) {
      log('Erro ao carregar treinos salvos: $e');
      _error = 'Não foi possível carregar seus treinos salvos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> savePlan({
    required String name,
    required ExerciseDifficulty difficulty,
    required List<Exercise> exercises,
  }) async {
    try {
      await _service.create(
        SavedPlan(
          name: name.trim(),
          difficulty: difficulty,
          exercises: exercises,
        ),
      );
      await loadPlans();
      return true;
    } catch (e) {
      log('Erro ao salvar treino: $e');
      _error = 'Não foi possível salvar o treino.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePlan(SavedPlan plan) async {
    try {
      await _service.update(plan);
      await loadPlans();
      return true;
    } catch (e) {
      log('Erro ao atualizar treino: $e');
      _error = 'Não foi possível atualizar o treino.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePlan(int id) async {
    try {
      await _service.delete(id);
      await loadPlans();
      return true;
    } catch (e) {
      log('Erro ao excluir treino: $e');
      _error = 'Não foi possível excluir o treino.';
      notifyListeners();
      return false;
    }
  }

  SavedPlan? planById(int id) {
    for (final plan in _plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }
}
