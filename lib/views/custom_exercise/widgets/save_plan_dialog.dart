import 'package:artriapp/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> showSavePlanDialog(
  BuildContext context, {
  String initialName = '',
  String title = 'Salvar treino',
  String confirmText = 'Salvar',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _SavePlanDialog(
      initialName: initialName,
      title: title,
      confirmText: confirmText,
    ),
  );
}

class _SavePlanDialog extends StatefulWidget {
  final String initialName;
  final String title;
  final String confirmText;

  const _SavePlanDialog({
    required this.initialName,
    required this.title,
    required this.confirmText,
  });

  @override
  State<_SavePlanDialog> createState() => _SavePlanDialogState();
}

class _SavePlanDialogState extends State<_SavePlanDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Dê um nome ao seu treino.');
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: GoogleFonts.montserrat(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (_) => _confirm(),
        style: GoogleFonts.montserrat(color: AppColors.darkGreen),
        decoration: InputDecoration(
          hintText: 'Ex.: Treino de segunda',
          errorText: _errorText,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkGreen, width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: GoogleFonts.montserrat(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: _confirm,
          child: Text(
            widget.confirmText,
            style: GoogleFonts.montserrat(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
