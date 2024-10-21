import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCorrectiveMaintenanceForm extends StatefulWidget {
  final BuildContext parentContext;
  final String vehicleId;
  final Map<String, dynamic> vehicleData;
  final Function(Map<String, dynamic>) onMaintenanceAdded;

  AddCorrectiveMaintenanceForm({
    required this.parentContext,
    required this.vehicleId,
    required this.vehicleData,
    required this.onMaintenanceAdded,
  });

  @override
  _AddCorrectiveMaintenanceFormState createState() =>
      _AddCorrectiveMaintenanceFormState();
}

class _AddCorrectiveMaintenanceFormState
    extends State<AddCorrectiveMaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String fechaUltimoMantenimiento = '';
  String razon = '';

  TextEditingController fechaController = TextEditingController();

  @override
  void dispose() {
    fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxWidth:
              600, // Ajustamos el ancho máximo para que coincida con otros formularios
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Agregar Mantenimiento Correctivo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Nombre del Mantenimiento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nombre = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha (YYYY-MM-DD)',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ),
                    controller: fechaController,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha';
                      }
                      if (DateTime.tryParse(value) == null) {
                        return 'Ingrese una fecha válida';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fechaUltimoMantenimiento = value!;
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Razón del Mantenimiento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la razón del mantenimiento';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      razon = value!;
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Agregar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        fechaUltimoMantenimiento = DateFormat('yyyy-MM-dd').format(pickedDate);
        fechaController.text = fechaUltimoMantenimiento;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> nuevoMantenimiento = {
        'nombre': nombre,
        'ultimo_mantenimiento_correctivo': fechaUltimoMantenimiento,
        'razon': razon,
      };

      // Actualizar el mantenimiento correctivo en el vehículo
      List<dynamic> mantenimientoCorrectivoActualizado =
          List.from(widget.vehicleData['mantenimiento_correctivo'] ?? []);
      mantenimientoCorrectivoActualizado.add(nuevoMantenimiento);

      // Crear el mapa actualizado del vehículo
      Map<String, dynamic> vehiculoActualizado = {
        ...widget.vehicleData,
        'mantenimiento_correctivo': mantenimientoCorrectivoActualizado,
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
          widget.onMaintenanceAdded(nuevoMantenimiento);

          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('Mantenimiento correctivo agregado exitosamente.'),
            ),
          );

          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('Error al agregar el mantenimiento correctivo.'),
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
}
