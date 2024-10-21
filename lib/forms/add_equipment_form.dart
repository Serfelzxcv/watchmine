import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEquipmentForm extends StatefulWidget {
  final BuildContext parentContext;
  final String vehicleId;
  final Map<String, dynamic> vehicleData;
  final Function(Map<String, dynamic>) onEquipmentAdded;

  AddEquipmentForm({
    required this.parentContext,
    required this.vehicleId,
    required this.vehicleData,
    required this.onEquipmentAdded,
  });

  @override
  _AddEquipmentFormState createState() => _AddEquipmentFormState();
}

class _AddEquipmentFormState extends State<AddEquipmentForm> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String fechaInstalacion = '';
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
              600, // Ancho máximo para que el formulario no sea tan angosto
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
                    'Agregar Equipamiento',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Nombre del Equipamiento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del equipamiento';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nombre = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha de Instalación (YYYY-MM-DD)',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ),
                    controller: fechaController,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha de instalación';
                      }
                      if (DateTime.tryParse(value) == null) {
                        return 'Ingrese una fecha válida';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fechaInstalacion = value!;
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Razón de Instalación'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la razón de la instalación';
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
        fechaInstalacion = DateFormat('yyyy-MM-dd').format(pickedDate);
        fechaController.text = fechaInstalacion;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> nuevoEquipamiento = {
        'nombre': nombre,
        'fecha_instalacion': fechaInstalacion,
        'razon': razon,
      };

      // Actualizar el equipamiento en el vehículo
      List<dynamic> equipamientoActualizado =
          List.from(widget.vehicleData['equipamiento'] ?? []);
      equipamientoActualizado.add(nuevoEquipamiento);

      // Crear el mapa actualizado del vehículo
      Map<String, dynamic> vehiculoActualizado = {
        ...widget.vehicleData,
        'equipamiento': equipamientoActualizado,
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
          widget.onEquipmentAdded(nuevoEquipamiento);

          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('Equipamiento agregado exitosamente.'),
            ),
          );

          Navigator.of(context).pop(); // Cerrar el formulario
        } else {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('Error al agregar el equipamiento.'),
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
