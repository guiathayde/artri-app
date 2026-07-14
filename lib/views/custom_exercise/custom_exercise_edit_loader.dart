import 'package:artriapp/utils/index.dart';
import 'package:artriapp/view_models/index.dart';
import 'package:artriapp/views/custom_exercise/custom_exercise_builder.dart';
import 'package:artriapp/views/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomExerciseEditLoader extends StatefulWidget {
  final int planId;

  const CustomExerciseEditLoader({super.key, required this.planId});

  @override
  State<CustomExerciseEditLoader> createState() =>
      _CustomExerciseEditLoaderState();
}

class _CustomExerciseEditLoaderState extends State<CustomExerciseEditLoader> {
  bool _ready = false;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _ready = false;
      _notFound = false;
    });

    final savedViewModel = context.read<SavedPlansViewModel>();
    var plan = savedViewModel.planById(widget.planId);
    if (plan == null) {
      await savedViewModel.loadPlans();
      plan = savedViewModel.planById(widget.planId);
    }
    if (!mounted) return;

    if (plan == null) {
      setState(() {
        _notFound = true;
        _ready = true;
      });
      return;
    }

    await context.read<CustomExercisesViewModel>().startForEdit(plan);
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_notFound) {
      return Center(
        child: Text(
          'Treino não encontrado.',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: AppColors.darkGreen,
          ),
        ),
      );
    }

    return Consumer<CustomExercisesViewModel>(
      builder: (context, viewModel, child) {
        if (!_ready || viewModel.isLoading) {
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
                  onPressed: _load,
                ),
              ],
            ),
          );
        }

        return const CustomExerciseBuilder();
      },
    );
  }
}
