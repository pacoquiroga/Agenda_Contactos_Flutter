import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/contactos.dart';

class ContactosController {
  final contactosApi = 'http://localhost:5000/api/personas';

  Future<List<Contacto>> getContactos() async {
    final response = await http.get(Uri.parse(contactosApi));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      List<Contacto> contactos =
          data.map((contacto) => Contacto.fromMap(contacto)).toList();
      return contactos;
    } else {
      throw Exception('Error al obtener los contactos');
    }
  }

  Future<void> crearContacto(Contacto contacto) async {
    final response = await http.post(Uri.parse(contactosApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(contacto.toMapForApi()));

    if (response.statusCode != 201) {
      throw Exception('Error al crear el contacto');
    }
  }

  Future<void> actualizarContacto(String id, Contacto contacto) async {
    final response = await http.put(Uri.parse('$contactosApi' + '/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(contacto.toMapForApi()));

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el contacto');
    }
  }

  Future<void> eliminarContacto(String id) async {
    final response = await http.delete(
      Uri.parse('$contactosApi' + "/$id"),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el contacto');
    }
  }
  
}
