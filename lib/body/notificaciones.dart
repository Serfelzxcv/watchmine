import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minewatch/body/vehicle_detail.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones(
      {Key? key, required List<Map<String, dynamic>> vehiculos})
      : super(key: key);

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  List<Map<String, dynamic>> vehiculos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehiculos();
  }

  Future<void> _fetchVehiculos() async {
    const String apiUrl = 'http://10.0.2.2:3001/vehicles';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          vehiculos =
              List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al realizar la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listaDeNotificaciones = _generarNotificaciones();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : listaDeNotificaciones.isNotEmpty
              ? Column(
                  children: listaDeNotificaciones.map((notificacion) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications_sharp,
                          color: notificacion['color'] == 'red'
                              ? Colors.red
                              : Colors.yellow,
                        ),
                        title: Text(
                          notificacion['mensaje'],
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          // Navegar a la pantalla de detalles del vehículo usando la información
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleDetail(
                                vehicle: notificacion['vehiculo'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                )
              : Center(
                  child: Text(
                    'No hay notificaciones de mantenimientos vencidos.',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
    );
  }

  List<Map<String, dynamic>> _generarNotificaciones() {
    List<Map<String, dynamic>> notificaciones = [];
    DateTime hoy = DateTime.now();

    for (var vehiculo in vehiculos) {
      final String placa = vehiculo['placa'] ?? 'Desconocida';
      final List<dynamic> mantenimientoPreventivo =
          vehiculo['mantenimiento_preventivo'] ?? [];

      for (var mantenimiento in mantenimientoPreventivo) {
        DateTime? fechaUltimoMantenimiento;
        try {
          fechaUltimoMantenimiento =
              DateTime.parse(mantenimiento['fecha_ultimo_mantenimiento']);
        } catch (e) {
          continue; // Si no se puede parsear la fecha, continuar con el siguiente.
        }

        int intervaloDias = mantenimiento['intervalo_dias'] ?? 0;
        DateTime fechaProximoMantenimiento =
            fechaUltimoMantenimiento.add(Duration(days: intervaloDias));

        int diasRestantes = fechaProximoMantenimiento.difference(hoy).inDays;

        // Verificar si el mantenimiento está vencido o próximo a vencerse (10 días o menos).
        if (diasRestantes < 0) {
          notificaciones.add({
            'mensaje':
                'El mantenimiento preventivo de $placa para "${mantenimiento['nombre']}" está vencido desde hace ${diasRestantes.abs()} días.',
            'color': 'red',
            'vehiculo':
                vehiculo, // Incluye el vehículo completo para navegación
          });
        } else if (diasRestantes <= 10) {
          notificaciones.add({
            'mensaje':
                'El mantenimiento preventivo de $placa para "${mantenimiento['nombre']}" vence en $diasRestantes días.',
            'color': 'yellow',
            'vehiculo':
                vehiculo, // Incluye el vehículo completo para navegación
          });
        }
      }
    }

    return notificaciones;
  }
}
