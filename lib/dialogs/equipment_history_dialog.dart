import 'package:flutter/material.dart';

class EquipmentHistoryDialog extends StatelessWidget {
  final List<dynamic> historialEquipamiento;

  EquipmentHistoryDialog({required this.historialEquipamiento});

  @override
  Widget build(BuildContext context) {
    List<dynamic> historialOrdenado = List.from(historialEquipamiento);
    historialOrdenado.sort((a, b) {
      DateTime fechaA =
          DateTime.tryParse(a['fecha_instalacion']) ?? DateTime(0);
      DateTime fechaB =
          DateTime.tryParse(b['fecha_instalacion']) ?? DateTime(0);
      return fechaB.compareTo(fechaA);
    });

    // Limitar el tamaño si hay más de 5 ítems
    final double dialogHeight = historialOrdenado.length > 5
        ? MediaQuery.of(context).size.height * 0.6 // Aumenta la altura máxima
        : historialOrdenado.length * 100.0; // Aumenta la altura por ítem

    return AlertDialog(
      title: Text('Historial de Equipamiento'),
      content: historialOrdenado.isNotEmpty
          ? SizedBox(
              width: double.maxFinite,
              height: dialogHeight,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                itemCount: historialOrdenado.length,
                itemBuilder: (context, index) {
                  final equipamiento = historialOrdenado[index];
                  String fecha =
                      equipamiento['fecha_instalacion'] ?? 'Fecha inválida';

                  return ListTile(
                    leading: Icon(Icons.inventory, color: Colors.blue),
                    title: Text(
                      equipamiento['nombre'] ?? 'Equipamiento',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Fecha: $fecha\nRazón: ${equipamiento['razon']}'),
                  );
                },
              ),
            )
          : Text('No hay historial de equipamientos registrados.'),
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
