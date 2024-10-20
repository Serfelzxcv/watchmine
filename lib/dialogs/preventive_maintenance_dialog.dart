import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreventiveMaintenanceDialog extends StatelessWidget {
  final List<dynamic> mantenimientoPreventivo;

  PreventiveMaintenanceDialog({required this.mantenimientoPreventivo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mantenimientos Preventivos'),
      content: mantenimientoPreventivo.isNotEmpty
          ? Container(
              width: double.maxFinite,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                itemCount: mantenimientoPreventivo.length,
                itemBuilder: (context, index) {
                  final mantenimiento = mantenimientoPreventivo[index];

                  // Parsear la fecha del último mantenimiento
                  DateTime? fechaUltimoMantenimiento;
                  try {
                    fechaUltimoMantenimiento = DateTime.parse(
                        mantenimiento['fecha_ultimo_mantenimiento']);
                  } catch (e) {
                    fechaUltimoMantenimiento = null;
                  }

                  // Calcular la fecha del próximo mantenimiento
                  DateTime? fechaProximoMantenimiento;
                  if (fechaUltimoMantenimiento != null) {
                    int intervaloDias = mantenimiento['intervalo_dias'] ?? 0;
                    fechaProximoMantenimiento = fechaUltimoMantenimiento
                        .add(Duration(days: intervaloDias));
                  }

                  // Formatear las fechas para mostrar
                  String fechaUltimoMantenimientoStr =
                      fechaUltimoMantenimiento != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(fechaUltimoMantenimiento)
                          : 'Fecha inválida';

                  String fechaProximoMantenimientoStr =
                      fechaProximoMantenimiento != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(fechaProximoMantenimiento)
                          : 'No calculable';

                  // Determinar el color del ícono según la proximidad del próximo mantenimiento
                  Color iconColor = Colors.grey; // Color por defecto
                  if (fechaProximoMantenimiento != null) {
                    DateTime hoy = DateTime.now();
                    Duration diferencia =
                        fechaProximoMantenimiento.difference(hoy);
                    int diasRestantes = diferencia.inDays;

                    if (diasRestantes < 0) {
                      // Fecha vencida
                      iconColor = Colors.red;
                    } else if (diasRestantes <= 10) {
                      // Faltan 10 días o menos
                      iconColor = Colors.yellow;
                    } else {
                      // Más de 10 días restantes
                      iconColor = Colors.green;
                    }
                  }

                  return ListTile(
                    leading: Icon(Icons.build, color: iconColor),
                    title: Text(
                      mantenimiento['nombre'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Último Mantenimiento: $fechaUltimoMantenimientoStr',
                        ),
                        Text(
                          'Próximo Mantenimiento: $fechaProximoMantenimientoStr',
                        ),
                        Text(
                          'Intervalo: ${mantenimiento['intervalo_dias']} días',
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Text('No hay mantenimientos preventivos registrados.'),
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
