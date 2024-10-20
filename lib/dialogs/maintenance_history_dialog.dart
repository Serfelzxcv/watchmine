import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceHistoryDialog extends StatelessWidget {
  final List<dynamic> historialMantenimientoPreventivo;

  MaintenanceHistoryDialog({required this.historialMantenimientoPreventivo});

  @override
  Widget build(BuildContext context) {
    // Crear una copia del historial y ordenarlo por fecha descendente
    List<dynamic> historialOrdenado =
        List.from(historialMantenimientoPreventivo);

    historialOrdenado.sort((a, b) {
      DateTime fechaA =
          DateTime.tryParse(a['fecha_ultimo_mantenimiento']) ?? DateTime(0);
      DateTime fechaB =
          DateTime.tryParse(b['fecha_ultimo_mantenimiento']) ?? DateTime(0);
      return fechaB
          .compareTo(fechaA); // Orden descendente: más reciente primero
    });

    // Calcular la altura dinámica basada en la cantidad de ítems (máximo 5 elementos visibles)
    int itemCount = historialOrdenado.length;
    double itemHeight = 80.0; // Altura estimada por cada ítem
    double maxHeight = itemCount > 5 ? itemHeight * 5 : itemHeight * itemCount;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: maxHeight + 100, // Ajustar el tamaño máximo del diálogo
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título del diálogo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Historial de Mantenimiento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            // Contenido del diálogo
            Expanded(
              child: historialOrdenado.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: historialOrdenado.length,
                      itemBuilder: (context, index) {
                        final mantenimiento = historialOrdenado[index];

                        // Parsear la fecha de último mantenimiento
                        DateTime? fechaUltimoMantenimiento;
                        try {
                          fechaUltimoMantenimiento = DateTime.parse(
                              mantenimiento['fecha_ultimo_mantenimiento']);
                        } catch (e) {
                          fechaUltimoMantenimiento = null;
                        }

                        // Formatear la fecha para mostrar
                        String fechaUltimoMantenimientoStr =
                            fechaUltimoMantenimiento != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(fechaUltimoMantenimiento)
                                : 'Fecha inválida';

                        return ListTile(
                          leading: Icon(Icons.history, color: Colors.blue),
                          title: Text(
                            mantenimiento['nombre'] ?? 'Mantenimiento',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha: $fechaUltimoMantenimientoStr',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Intervalo: ${mantenimiento['intervalo_dias'] ?? 'N/A'} días',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No hay historial de mantenimientos registrados.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
            ),
            // Botón de cerrar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
