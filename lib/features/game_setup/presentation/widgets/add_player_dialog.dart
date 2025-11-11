import 'package:flutter/material.dart';
import '../../../../core/constants/game_constants.dart';

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({super.key});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(GameConstants.addPlayer),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: GameConstants.playerName,
            hintText: 'Ej: María',
            prefixIcon: const Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return GameConstants.errorEmptyPlayerName;
            }
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(GameConstants.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(GameConstants.accept),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }
}

