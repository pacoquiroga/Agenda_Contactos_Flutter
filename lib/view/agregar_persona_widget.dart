import 'package:agenda_contactos/controller/contactos_controller.dart';
import 'package:agenda_contactos/model/contactos.dart';
import 'package:flutter/material.dart';

class AgregarPersona extends StatelessWidget {
  final Function(String nombre, String apellido, String telefono) onGuardar;
  final String title;
  final Contacto? contacto;

  AgregarPersona({
    required this.onGuardar,
    required this.title,
    this.contacto,
  }) {
    if (contacto != null) {
      _nombreController.text = contacto!.nombre;
      _apellidoController.text = contacto!.apellido;
      _telefonoController.text = contacto!.telefono;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();

  final ContactosController contactosController = ContactosController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$title Contacto',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nombreController,
                label: 'Nombre',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _apellidoController,
                label: 'Apellido',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _telefonoController,
                label: 'Teléfono',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onGuardar(
                      _nombreController.text,
                      _apellidoController.text,
                      _telefonoController.text,
                    );
                  }
                },
                child: const Text(
                  'Guardar Contacto',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: (value) =>
          value!.isEmpty ? 'Por favor ingresa tu $label' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
      ),
    );
  }
}
