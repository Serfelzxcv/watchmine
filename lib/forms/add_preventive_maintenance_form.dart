import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPreventiveMaintenanceForm extends StatefulWidget {
  final BuildContext parentContext;
  final String vehicleId;
  final Map<String, dynamic> vehicleData;
  final Function(Map<String, dynamic>) onMaintenanceAdded;

  // Nuevo parámetro opcional para edición
  final Map<String, dynamic>? existingMaintenance;

  AddPreventiveMaintenanceForm({
    required this.parentContext,
    required this.vehicleId,
    required this.vehicleData,
    required this.onMaintenanceAdded,
    this.existingMaintenance,
  });

  @override
  _AddPreventiveMaintenanceFormState createState() =>
      _AddPreventiveMaintenanceFormState();
}

class _AddPreventiveMaintenanceFormState
    extends State<AddPreventiveMaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  late String id; // Agregamos el campo id
  late String nombre;
  late String fechaUltimoMantenimiento;
  late int intervaloDias;

  TextEditingController fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingMaintenance != null) {
      // Si se está editando, inicializar los campos con los valores existentes
      id = widget.existingMaintenance!['id']; // Obtenemos el id existente
      nombre = widget.existingMaintenance!['nombre'] ?? '';
      fechaUltimoMantenimiento =
          widget.existingMaintenance!['fecha_ultimo_mantenimiento'] ?? '';
      intervaloDias = widget.existingMaintenance!['intervalo_dias'] ?? 0;

      fechaController.text = fechaUltimoMantenimiento;
    } else {
      // Si es un nuevo mantenimiento
      id = UniqueKey().toString(); // Generamos un id único
      nombre = '';
      fechaUltimoMantenimiento = '';
      intervaloDias = 0;
    }
  }

  @override
  void dispose() {
    fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingMaintenance != null
          ? 'Editar Mantenimiento Preventivo'
          : 'Agregar Mantenimiento Preventivo'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: nombre,
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
                initialValue: intervaloDias != 0 ? '$intervaloDias' : '',
                decoration: InputDecoration(labelText: 'Intervalo en días'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el intervalo';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  intervaloDias = int.parse(value!);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el formulario
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child:
              Text(widget.existingMaintenance != null ? 'Guardar' : 'Agregar'),
        ),
      ],
    );
  }

  void _selectDate() async {
    DateTime initialDate;
    if (fechaController.text.isNotEmpty) {
      initialDate = DateTime.parse(fechaController.text);
    } else {
      initialDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000), // Fecha mínima
      lastDate: DateTime(2100), // Fecha máxima
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
        'id': id, // Incluimos el id
        'nombre': nombre,
        'fecha_ultimo_mantenimiento': fechaUltimoMantenimiento,
        'intervalo_dias': intervaloDias,
      };

      // Crear una copia del mantenimiento preventivo actual
      List<dynamic> mantenimientoPreventivoActualizado =
          List.from(widget.vehicleData['mantenimiento_preventivo'] ?? []);

      if (widget.existingMaintenance != null) {
        // Editar mantenimiento existente
        int index = mantenimientoPreventivoActualizado
            .indexWhere((element) => element['id'] == id);
        if (index != -1) {
          mantenimientoPreventivoActualizado[index] = nuevoMantenimiento;
        }
      } else {
        // Agregar nuevo mantenimiento
        mantenimientoPreventivoActualizado.add(nuevoMantenimiento);
      }

      // Crear el mapa actualizado del vehículo sin modificar el original
      Map<String, dynamic> vehiculoActualizado = {
        ...widget.vehicleData,
        'mantenimiento_preventivo': mantenimientoPreventivoActualizado,
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
          // Llamar al callback para actualizar la lista en el diálogo principal
          widget.onMaintenanceAdded(nuevoMantenimiento);

          // Mostrar SnackBar en el contexto del padre
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text(widget.existingMaintenance != null
                  ? 'Mantenimiento preventivo actualizado exitosamente.'
                  : 'Mantenimiento preventivo agregado exitosamente.'),
            ),
          );

          Navigator.of(context).pop(); // Cerrar el formulario
        } else {
          // Error en la actualización
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('Error al guardar el mantenimiento preventivo.'),
            ),
          );
        }
      } catch (e) {
        // Manejar excepciones de red
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            content: Text('Ocurrió un error: $e'),
          ),
        );
      }
    }
  }
}
