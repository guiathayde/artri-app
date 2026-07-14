import 'package:artriapp/models/index.dart';
import 'package:artriapp/routes/index.dart';
import 'package:artriapp/utils/helpers/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:artriapp/view_models/index.dart';
import 'package:artriapp/views/physical_exercise/widgets/index.dart';
import 'package:artriapp/views/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SavedPlansView extends StatefulWidget {
  const SavedPlansView({super.key});

  @override
  State<SavedPlansView> createState() => _SavedPlansViewState();
}

class _SavedPlansViewState extends State<SavedPlansView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedPlansViewModel>().loadPlans();
    });
  }

  Future<void> _start(BuildContext context, SavedPlan plan) async {
    final physicalViewModel = context.read<PhysicalExercisesViewModel>();

    await showDialog(
      context: context,
      builder: (context) => const OrientationsDialog(),
    );
    if (!context.mounted) return;

    physicalViewModel.startQueue(plan.exercises, context);
  }

  void _edit(BuildContext context, SavedPlan plan) {
    context.go('${PhysicalExerciseRoutes.savedPlans}/edit/${plan.id}');
  }

  Future<void> _delete(BuildContext context, SavedPlan plan) async {
    final viewModel = context.read<SavedPlansViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Excluir treino',
          style: GoogleFonts.montserrat(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir "${plan.name}"? '
          'Essa ação não pode ser desfeita.',
          style: GoogleFonts.montserrat(color: AppColors.darkGreen),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.montserrat(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Excluir',
              style: GoogleFonts.montserrat(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && plan.id != null) {
      await viewModel.deletePlan(plan.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedPlansViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.darkGreen),
          );
        }

        if (viewModel.error != null) {
          return _CenteredMessage(
            message: viewModel.error!,
            actionText: 'Tentar novamente',
            onAction: viewModel.loadPlans,
          );
        }

        if (viewModel.isEmpty) {
          return _CenteredMessage(
            message: 'Você ainda não salvou nenhum treino.\n\n'
                'Monte um treino personalizado e toque em "Salvar treino" '
                'para acessá-lo aqui depois.',
            actionText: 'Montar um treino',
            onAction: () => context.go(PhysicalExerciseRoutes.customExercises),
          );
        }

        return RefreshIndicator(
          color: AppColors.darkGreen,
          onRefresh: viewModel.loadPlans,
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: viewModel.plans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final plan = viewModel.plans[index];
              return _SavedPlanCard(
                plan: plan,
                onStart: () => _start(context, plan),
                onEdit: () => _edit(context, plan),
                onDelete: () => _delete(context, plan),
              );
            },
          ),
        );
      },
    );
  }
}

class _SavedPlanCard extends StatelessWidget {
  final SavedPlan plan;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SavedPlanCard({
    required this.plan,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final level =
        DifficultyHelper.getDifficultyText(plan.difficulty.toString());
    final count = plan.exerciseCount;
    final subtitle =
        '${level ?? ''} • $count ${count == 1 ? 'exercício' : 'exercícios'}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkGreenSurface, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.name,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomSolidButton(
                  text: 'Iniciar',
                  fontSize: 20,
                  borderRadius: 12,
                  gradientColors: AppGradients.greenGradient,
                  onPressed: onStart,
                ),
              ),
              const SizedBox(width: 8),
              _IconAction(
                icon: Icons.edit,
                tooltip: 'Editar',
                color: AppColors.darkGreen,
                onPressed: onEdit,
              ),
              const SizedBox(width: 8),
              _IconAction(
                icon: Icons.delete_outline,
                tooltip: 'Excluir',
                color: Colors.red,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        style: IconButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onAction;

  const _CenteredMessage({
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: AppColors.darkGreen,
            ),
          ),
          CustomSolidButton(
            text: actionText,
            fontSize: 20,
            gradientColors: AppGradients.greenGradient,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}
