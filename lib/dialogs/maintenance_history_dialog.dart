import 'package:flutter/material.dart';

class MaintenanceHistoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Historial de Mantenimiento'),
      content: Text('historial dialog'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
