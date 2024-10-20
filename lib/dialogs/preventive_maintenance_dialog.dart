import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minewatch/forms/add_preventive_maintenance_form.dart';

class PreventiveMaintenanceDialog extends StatefulWidget {
  final BuildContext parentContext;
  final String vehicleId;
  final Map<String, dynamic> vehicleData;
  final List<dynamic> mantenimientoPreventivo;

  PreventiveMaintenanceDialog({
    required this.parentContext,
    required this.vehicleId,
    required this.vehicleData,
    required this.mantenimientoPreventivo,
  });

  @override
  _PreventiveMaintenanceDialogState createState() =>
      _PreventiveMaintenanceDialogState();
}

class _PreventiveMaintenanceDialogState
    extends State<PreventiveMaintenanceDialog> {
  late List<dynamic> mantenimientoPreventivoOrdenado;

  @override
  void initState() {
    super.initState();
    _ordenarMantenimientos();
  }

  void _ordenarMantenimientos() {
    // Crear una copia y ordenar por fecha
    mantenimientoPreventivoOrdenado = List.from(widget.mantenimientoPreventivo);

    mantenimientoPreventivoOrdenado.sort((a, b) {
      DateTime fechaA =
          DateTime.tryParse(a['fecha_ultimo_mantenimiento']) ?? DateTime(0);
      DateTime fechaB =
          DateTime.tryParse(b['fecha_ultimo_mantenimiento']) ?? DateTime(0);
      return fechaB.compareTo(fechaA); // Orden descendente
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta la altura al contenido
          children: [
            // Título del diálogo con el botón "+"
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Mantenimientos Preventivos',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.blue),
                    onPressed: _showAddPreventiveMaintenanceForm,
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            // Contenido del diálogo
            mantenimientoPreventivoOrdenado.isNotEmpty
                ? Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey),
                      itemCount: mantenimientoPreventivoOrdenado.length,
                      itemBuilder: (context, index) {
                        final mantenimiento =
                            mantenimientoPreventivoOrdenado[index];

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
                          int intervaloDias =
                              mantenimiento['intervalo_dias'] ?? 0;
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

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.build, color: iconColor),
                                title: Text(
                                  mantenimiento['nombre'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Texto negro
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Último Mantenimiento: $fechaUltimoMantenimientoStr',
                                      style: TextStyle(color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Próximo Mantenimiento: $fechaProximoMantenimientoStr',
                                      style: TextStyle(color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Intervalo: ${mantenimiento['intervalo_dias']} días',
                                      style: TextStyle(color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Botones de acción
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _editMaintenance(mantenimiento);
                                    },
                                    child: Text('Editar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteMaintenance(mantenimiento);
                                    },
                                    child: Text('Eliminar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showConfirmationDialog(mantenimiento);
                                    },
                                    child: Text('Realizado'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No hay mantenimientos preventivos registrados.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
            // Botón de cerrar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar el formulario de edición
  void _editMaintenance(Map<String, dynamic> mantenimiento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPreventiveMaintenanceForm(
          parentContext: widget.parentContext,
          vehicleId: widget.vehicleId,
          vehicleData: widget.vehicleData,
          onMaintenanceAdded: _onMaintenanceEdited,
          existingMaintenance: mantenimiento,
        );
      },
    );
  }

  // Método para manejar la edición de mantenimiento
  void _onMaintenanceEdited(Map<String, dynamic> mantenimientoEditado) {
    setState(() {
      int index = widget.mantenimientoPreventivo
          .indexWhere((element) => element['id'] == mantenimientoEditado['id']);
      if (index != -1) {
        // Reemplazamos el mantenimiento editado en la lista original
        widget.mantenimientoPreventivo[index] = mantenimientoEditado;
        // Actualizamos la lista ordenada también
        _ordenarMantenimientos();
      }
    });
  }

  // Método para eliminar un mantenimiento
  void _deleteMaintenance(Map<String, dynamic> mantenimiento) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text(
              '¿Está seguro de que desea eliminar el mantenimiento "${mantenimiento['nombre']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      setState(() {
        widget.mantenimientoPreventivo.remove(mantenimiento);
        _ordenarMantenimientos();
      });

      // Actualizar en el servidor
      Map<String, dynamic> vehiculoActualizado = {
        ...widget.vehicleData,
        'mantenimiento_preventivo': widget.mantenimientoPreventivo,
      };

      String apiUrl = 'http://10.0.2.2:3001/vehicles/${widget.vehicleId}';

      try {
        var response = await http.put(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(vehiculoActualizado),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text(
                  'El mantenimiento "${mantenimiento['nombre']}" ha sido eliminado.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar el mantenimiento.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            content: Text('Ocurrió un error: $e'),
          ),
        );
      }
    }
  }

  void _showConfirmationDialog(Map<String, dynamic> mantenimiento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirmación',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            '¿Ha realizado el mantenimiento "${mantenimiento['nombre']}"?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Lógica si se elige "No"
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _registrarMantenimientoRealizado(mantenimiento);
              },
              child: Text(
                'Sí',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _registrarMantenimientoRealizado(
      Map<String, dynamic> mantenimiento) async {
    String fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Actualizar la fecha del último mantenimiento localmente
    setState(() {
      mantenimiento['fecha_ultimo_mantenimiento'] = fechaActual;
    });

    // Actualizar el mantenimiento preventivo en el vehículo
    List<dynamic> mantenimientoPreventivoActualizado =
        List.from(widget.mantenimientoPreventivo);

    // Crear el nuevo registro para el historial
    Map<String, dynamic> nuevoHistorial = {
      'nombre': mantenimiento['nombre'],
      'fecha_ultimo_mantenimiento': fechaActual,
      'intervalo_dias': mantenimiento['intervalo_dias'],
    };

    // Obtener el historial actual y agregar el nuevo registro
    List<dynamic> historialActual =
        widget.vehicleData['historial_mantenimiento_preventivo'] ?? [];
    historialActual.add(nuevoHistorial);

    // Crear el mapa actualizado del vehículo
    Map<String, dynamic> vehiculoActualizado = {
      ...widget.vehicleData,
      'mantenimiento_preventivo': mantenimientoPreventivoActualizado,
      'historial_mantenimiento_preventivo': historialActual,
    };

    // URL de la API
    String apiUrl = 'http://10.0.2.2:3001/vehicles/${widget.vehicleId}';

    // Realizar la solicitud PUT para actualizar el vehículo
    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vehiculoActualizado),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mostrar SnackBar en el contexto del padre
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            backgroundColor: Colors.yellow,
            content: Text(
              'El mantenimiento "${mantenimiento['nombre']}" ha sido registrado como realizado.',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );

        setState(() {
          _ordenarMantenimientos();
        });
      } else {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar el mantenimiento.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error: $e'),
        ),
      );
    }
  }

  void _showAddPreventiveMaintenanceForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPreventiveMaintenanceForm(
          parentContext: widget.parentContext,
          vehicleId: widget.vehicleId,
          vehicleData: widget.vehicleData,
          onMaintenanceAdded: _onMaintenanceAdded,
        );
      },
    );
  }

  void _onMaintenanceAdded(Map<String, dynamic> nuevoMantenimiento) {
    setState(() {
      widget.mantenimientoPreventivo.add(nuevoMantenimiento);
      _ordenarMantenimientos();
    });
  }
}
