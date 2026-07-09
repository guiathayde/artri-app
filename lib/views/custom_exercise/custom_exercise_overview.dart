import 'package:artriapp/routes/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:artriapp/view_models/index.dart';
import 'package:artriapp/views/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomExerciseOverview extends StatefulWidget {
  final ExerciseDifficulty difficulty;

  const CustomExerciseOverview({super.key, required this.difficulty});

  @override
  State<CustomExerciseOverview> createState() => _CustomExerciseOverviewState();
}

class _CustomExerciseOverviewState extends State<CustomExerciseOverview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<CustomExercisesViewModel>();
      if (viewModel.difficulty != widget.difficulty) {
        viewModel.start(widget.difficulty);
      }
    });
  }

  void _openBuilder(BuildContext context, int stepIndex) {
    context.read<CustomExercisesViewModel>().goToStep(stepIndex);
    context.go(
      '${PhysicalExerciseRoutes.customExercises}/${widget.difficulty}/build',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomExercisesViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.darkGreen),
          );
        }

        if (viewModel.loadError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                Text(
                  viewModel.loadError!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: AppColors.darkGreen,
                  ),
                ),
                CustomSolidButton(
                  text: 'Tentar novamente',
                  fontSize: 20,
                  gradientColors: AppGradients.greenGradient,
                  onPressed: () => viewModel.start(widget.difficulty),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [
                    Text(
                      'Vamos começar a montar sua rotina de exercícios '
                      'personalizada de hoje! Clique para escolher os '
                      'exercícios indicados abaixo:',
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    for (var i = 0; i < viewModel.steps.length; i++)
                      _CategoryRow(
                        count:
                            viewModel.steps[i].totalRequired(widget.difficulty),
                        suffix: viewModel.steps[i].overviewSuffix,
                        onTap: () => _openBuilder(context, i),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomSolidButton(
              text: 'COMEÇAR',
              gradientColors: AppGradients.greenGradient,
              textStyle: GoogleFonts.montserrat(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () => _openBuilder(context, 0),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final int count;
  final String suffix;
  final VoidCallback onTap;

  const _CategoryRow({
    required this.count,
    required this.suffix,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit, color: Colors.grey, size: 28),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  color: AppColors.darkGreen,
                ),
                children: [
                  TextSpan(text: 'Escolha $count exercícios '),
                  TextSpan(
                    text: suffix,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
