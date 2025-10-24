import 'package:flutter/material.dart';
import 'package:hw/features/usuario/controllers/api_usuario.dart'; // ajusta el import según tu estructura
import 'package:hw/features/usuario/pages/usuario_form_page.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  bool loading = false;
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    setState(() => loading = true);
    try {
      final res = await ApiUsuario.getUsuarios();
      setState(() => usuarios = res);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _eliminarUsuario(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Seguro que deseas eliminar este usuario?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      await ApiUsuario.eliminarUsuario(id);
      _loadUsuarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsuarioFormPage()),
              );
              _loadUsuarios();
            },
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
          ? const Center(child: Text('No hay usuarios'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Usuario')),
            DataColumn(label: Text('Correo')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: usuarios.map((u) {
            return DataRow(cells: [
              DataCell(Text(u['id'].toString())),
              DataCell(Text(u['usuario'] ?? '')),
              DataCell(Text(u['correoelectronico'] ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UsuarioFormPage(usuario: u),
                        ),
                      );
                      _loadUsuarios();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarUsuario(u['id']),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}