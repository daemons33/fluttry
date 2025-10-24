import 'package:flutter/material.dart';
import 'package:hw/features/usuario/controllers/api_usuario.dart';

class UsuarioFormPage extends StatefulWidget {
  final Map<String, dynamic>? usuario;
  const UsuarioFormPage({Key? key, this.usuario}) : super(key: key);

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _contraseniaCtrl = TextEditingController();
  final _idpersonaCtrl = TextEditingController();
  final _idtipoCtrl = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _usuarioCtrl.text = widget.usuario!['usuario'] ?? '';
      _correoCtrl.text = widget.usuario!['correoelectronico'] ?? '';
      _idpersonaCtrl.text = widget.usuario!['idpersona']?.toString() ?? '';
      _idtipoCtrl.text = widget.usuario!['idtipo']?.toString() ?? '';
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'usuario': _usuarioCtrl.text,
      'correoelectronico': _correoCtrl.text,
      'contrasenia': _contraseniaCtrl.text,
      'idpersona': _idpersonaCtrl.text.isEmpty ? null : int.parse(_idpersonaCtrl.text),
      'idtipo': int.parse(_idtipoCtrl.text),
    };

    setState(() => loading = true);
    try {
      if (widget.usuario == null) {
        await ApiUsuario.crearUsuario(data);
      } else {
        await ApiUsuario.actualizarUsuario(widget.usuario!['id'], data);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.usuario != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Usuario' : 'Nuevo Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usuarioCtrl,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _correoCtrl,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              if (!isEdit)
                TextFormField(
                  controller: _contraseniaCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  validator: (v) => v == null || v.isEmpty ? 'Requerida' : null,
                ),
              TextFormField(
                controller: _idpersonaCtrl,
                decoration: const InputDecoration(labelText: 'ID Persona (opcional)'),
              ),
              TextFormField(
                controller: _idtipoCtrl,
                decoration: const InputDecoration(labelText: 'ID Tipo'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _guardar,
                child: Text(isEdit ? 'Guardar cambios' : 'Crear usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
