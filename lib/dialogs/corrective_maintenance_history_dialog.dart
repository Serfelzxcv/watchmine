import 'package:flutter/material.dart';

class CorrectiveMaintenanceHistoryDialog extends StatelessWidget {
  final List<dynamic> historialCorrectivo;

  CorrectiveMaintenanceHistoryDialog({required this.historialCorrectivo});

  @override
  Widget build(BuildContext context) {
    List<dynamic> historialOrdenado = List.from(historialCorrectivo);
    historialOrdenado.sort((a, b) {
      DateTime fechaA =
          DateTime.tryParse(a['ultimo_mantenimiento_correctivo']) ??
              DateTime(0);
      DateTime fechaB =
          DateTime.tryParse(b['ultimo_mantenimiento_correctivo']) ??
              DateTime(0);
      return fechaB.compareTo(fechaA);
    });

    // Limitar el tamaño si hay más de 5 ítems
    final double dialogHeight = historialOrdenado.length > 5
        ? MediaQuery.of(context).size.height * 0.6 // Aumenta la altura máxima
        : historialOrdenado.length * 100.0; // Aumenta la altura por ítem

    return AlertDialog(
      title: Text('Historial de Mantenimiento Correctivo'),
      content: historialOrdenado.isNotEmpty
          ? SizedBox(
              width: double.maxFinite,
              height: dialogHeight,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                itemCount: historialOrdenado.length,
                itemBuilder: (context, index) {
                  final mantenimiento = historialOrdenado[index];
                  String fecha =
                      mantenimiento['ultimo_mantenimiento_correctivo'] ??
                          'Fecha inválida';

                  return ListTile(
                    leading: Icon(Icons.build, color: Colors.blue),
                    title: Text(
                      mantenimiento['nombre'] ?? 'Mantenimiento',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Fecha: $fecha\nRazón: ${mantenimiento['razon']}'),
                  );
                },
              ),
            )
          : Text('No hay historial de mantenimientos correctivos registrados.'),
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
