import 'package:agenda_contactos/controller/contactos_controller.dart';
import 'package:agenda_contactos/model/contactos.dart';
import 'package:agenda_contactos/view/agregar_persona_widget.dart';
import 'package:flutter/material.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late Future<List<Contacto>> contactos;

  ContactosController contactosController = ContactosController();

  @override
  void initState() {
    super.initState();
    contactos = contactosController.getContactos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agenda de contactos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Contacto>>(
        future: contactos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final contacto = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        contacto.nombre[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      '${contacto.nombre} ${contacto.apellido}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      contacto.telefono,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.brown),
                          onPressed: () {
                            _showEditarPersonaModal(context, contacto);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await contactosController
                                .eliminarContacto(contacto.id);

                            setState(() {
                              contactos = contactosController.getContactos();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Contacto eliminado: ${contacto.nombre} ${contacto.apellido} (${contacto.telefono}).'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No hay contactos disponibles',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAgregarPersonaModal(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showEditarPersonaModal(BuildContext context, contacto) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AgregarPersona(
            contacto: contacto,
            title: 'Editar',
            onGuardar: (nombre, apellido, telefono) async {
              try {
                await contactosController.actualizarContacto(
                    contacto.id,
                    Contacto(
                      id: '',
                      nombre: nombre,
                      apellido: apellido,
                      telefono: telefono,
                      createdAt: '',
                      updatedAt: '',
                    ));

                Navigator.pop(context);

                setState(() {
                  contactos = contactosController.getContactos();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Contacto actualizado: $nombre $apellido ($telefono).'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al actualizar el contacto: $e'),
                  ),
                );
              }
            },
          );
        });
  }

  void _showAgregarPersonaModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AgregarPersona(
          title: 'Agregar',
          onGuardar: (nombre, apellido, telefono) async {
            try {
              await ContactosController().crearContacto(Contacto(
                id: '',
                nombre: nombre,
                apellido: apellido,
                telefono: telefono,
                createdAt: '',
                updatedAt: '',
              ));

              Navigator.pop(context);
              setState(() {
                contactos = ContactosController().getContactos();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Nuevo contacto agregado: $nombre $apellido ($telefono).'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al guardar el contacto: $e'),
                ),
              );
            }
          },
        );
      },
    );
  }
}
