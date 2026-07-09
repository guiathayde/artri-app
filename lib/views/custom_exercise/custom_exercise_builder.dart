import 'package:artriapp/routes/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:artriapp/view_models/index.dart';
import 'package:artriapp/views/custom_exercise/widgets/custom_exercise_option_tile.dart';
import 'package:artriapp/views/custom_exercise/widgets/save_plan_dialog.dart';
import 'package:artriapp/views/physical_exercise/widgets/index.dart';
import 'package:artriapp/views/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomExerciseBuilder extends StatelessWidget {
  const CustomExerciseBuilder({super.key});

  void _showHint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selecione exatamente a quantidade de exercícios indicada para continuar.',
        ),
      ),
    );
  }

  Future<void> _startWorkout(
    BuildContext context,
    CustomExercisesViewModel customViewModel,
  ) async {
    final physicalViewModel = context.read<PhysicalExercisesViewModel>();

    await showDialog(
      context: context,
      builder: (context) => const OrientationsDialog(),
    );
    if (!context.mounted) return;

    physicalViewModel.startQueue(customViewModel.orderedSelection(), context);
  }

  Future<void> _savePlan(
    BuildContext context,
    CustomExercisesViewModel customViewModel,
  ) async {
    if (!customViewModel.isPlanComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todas as categorias para salvar o treino.'),
        ),
      );
      return;
    }

    final savedViewModel = context.read<SavedPlansViewModel>();
    final name = await showSavePlanDialog(context);
    if (name == null || !context.mounted) return;

    final ok = await savedViewModel.savePlan(
      name: name,
      difficulty: customViewModel.difficulty!,
      exercises: customViewModel.orderedSelection(),
    );
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Treino "$name" salvo!' : 'Não foi possível salvar o treino.',
        ),
      ),
    );
  }

  Future<void> _saveEdits(
    BuildContext context,
    CustomExercisesViewModel customViewModel,
  ) async {
    final plan = customViewModel.editingPlan;
    if (plan == null) return;

    if (!customViewModel.isPlanComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todas as categorias para salvar o treino.'),
        ),
      );
      return;
    }

    final savedViewModel = context.read<SavedPlansViewModel>();
    final name = await showSavePlanDialog(
      context,
      initialName: plan.name,
      title: 'Salvar alterações',
      confirmText: 'Salvar',
    );
    if (name == null || !context.mounted) return;

    final ok = await savedViewModel.updatePlan(
      plan.copyWith(name: name, exercises: customViewModel.orderedSelection()),
    );
    if (!context.mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treino atualizado.')),
      );
      context.go(PhysicalExerciseRoutes.savedPlans);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar as alterações.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomExercisesViewModel>(
      builder: (context, viewModel, child) {
        final difficulty = viewModel.difficulty;
        if (difficulty == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.darkGreen),
          );
        }

        final step = viewModel.currentStep;
        final complete = viewModel.isCurrentStepComplete;
        final isLast = viewModel.isLastStep;
        final isEditing = viewModel.isEditing;

        return PopScope(
          canPop: viewModel.stepIndex == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) viewModel.back();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      for (final group in step.groups) ...[
                        Text(
                          group.prompt(difficulty),
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        for (final exercise in viewModel.catalogFor(group.key))
                          CustomExerciseOptionTile(
                            exercise: exercise,
                            selected:
                                viewModel.isSelected(group.key, exercise.id),
                            onToggle: () =>
                                viewModel.toggle(group, exercise.id),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (isEditing)
                CustomSolidButton(
                  text: isLast ? 'SALVAR ALTERAÇÕES' : 'PRÓXIMO',
                  fontSize: isLast ? 24 : 30,
                  gradientColors: (isLast ? viewModel.isPlanComplete : complete)
                      ? AppGradients.greenGradient
                      : null,
                  color: (isLast ? viewModel.isPlanComplete : complete)
                      ? null
                      : Colors.grey,
                  textStyle: GoogleFonts.montserrat(
                    fontSize: isLast ? 24 : 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    if (isLast) {
                      _saveEdits(context, viewModel);
                    } else {
                      if (!complete) {
                        _showHint(context);
                        return;
                      }
                      viewModel.next();
                    }
                  },
                )
              else ...[
                CustomSolidButton(
                  text: isLast ? 'COMEÇAR' : 'PRÓXIMO',
                  gradientColors: complete ? AppGradients.greenGradient : null,
                  color: complete ? null : Colors.grey,
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    if (!complete) {
                      _showHint(context);
                      return;
                    }
                    if (isLast) {
                      _startWorkout(context, viewModel);
                    } else {
                      viewModel.next();
                    }
                  },
                ),
                if (isLast) ...[
                  const SizedBox(height: 12),
                  CustomOutlinedButton(
                    text: 'Salvar treino',
                    fontSize: 24,
                    borderWidth: 2,
                    color: AppColors.darkGreen,
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () => _savePlan(context, viewModel),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
