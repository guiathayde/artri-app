import 'package:artriapp/routes/index.dart';
import 'package:artriapp/utils/enums/index.dart';
import 'package:artriapp/utils/helpers/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:artriapp/views/physical_exercise/widgets/index.dart';
import 'package:artriapp/views/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLevelSelector extends StatelessWidget {
  const CustomLevelSelector({super.key});

  void _select(BuildContext context, ExerciseDifficulty difficulty) {
    context.go('${PhysicalExerciseRoutes.customExercises}/$difficulty');
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenHelper.getScreenWidth(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 40,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Escolha um nível de dificuldade para montar o seu treino personalizado:',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 24,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          ExerciseButton(
            onClick: () => _select(context, ExerciseDifficulty.easy),
            side: ExerciseButtonSide.left,
            buttonText: 'Iniciante',
            color: AppColors.neutral,
            width: screenWidth * 0.65,
          ),
          ExerciseButton(
            onClick: () => _select(context, ExerciseDifficulty.medium),
            side: ExerciseButtonSide.left,
            buttonText: 'Intermediário',
            color: AppColors.neutral,
            width: screenWidth * 0.65,
          ),
          ExerciseButton(
            onClick: () => _select(context, ExerciseDifficulty.hard),
            side: ExerciseButtonSide.left,
            buttonText: 'Avançado',
            color: AppColors.neutral,
            width: screenWidth * 0.65,
          ),
          CustomSolidButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => LevelSelectorDialog(),
            ),
            text: 'Qual devo escolher?',
            color: AppColors.lightBrown,
            width: screenWidth * 0.80,
            textStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          CustomSolidButton(
            onPressed: () => context.go(PhysicalExerciseRoutes.savedPlans),
            text: 'Meus treinos salvos',
            gradientColors: AppGradients.greenGradient,
            width: screenWidth * 0.80,
            textStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
