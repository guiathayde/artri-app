import 'package:artriapp/models/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:artriapp/views/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomExerciseOptionTile extends StatelessWidget {
  final Exercise exercise;
  final bool selected;
  final VoidCallback onToggle;

  const CustomExerciseOptionTile({
    super.key,
    required this.exercise,
    required this.selected,
    required this.onToggle,
  });

  void _previewVideo(BuildContext context) {
    if (exercise.tutorialLink.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vídeo indisponível para este exercício.'),),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                exercise.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: VideoPlayerWidget(videoUrl: exercise.tutorialLink),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double thumb = width * 0.15;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _previewVideo(context),
            child: Container(
              height: thumb,
              width: thumb,
              decoration: BoxDecoration(
                color: AppColors.lightBrown,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: width * 0.09,
              ),
            ),
          ),
          Expanded(
            child: Text(
              exercise.name,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          _CheckBox(selected: selected),
        ],
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool selected;
  const _CheckBox({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: selected ? AppColors.mediumGreen : Colors.transparent,
        border: Border.all(color: AppColors.darkGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: selected
          ? const Icon(Icons.check, color: Colors.white, size: 24)
          : null,
    );
  }
}
