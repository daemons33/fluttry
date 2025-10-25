import 'package:flutter/material.dart';
import 'package:hw/features/plan/controllers/api_plan.dart';

class PlanFormPage extends StatefulWidget {
  final Map<String, dynamic>? plan;
  const PlanFormPage({Key? key, this.plan}) : super(key: key);

  @override
  State<PlanFormPage> createState() => _PlanFormPageState();
}

class _PlanFormPageState extends State<PlanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _planCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _contraseniaCtrl = TextEditingController();
  final _idpersonaCtrl = TextEditingController();
  final _idtipoCtrl = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _planCtrl.text = widget.plan!['plan'] ?? '';
      _correoCtrl.text = widget.plan!['correoelectronico'] ?? '';
      _idpersonaCtrl.text = widget.plan!['idpersona']?.toString() ?? '';
      _idtipoCtrl.text = widget.plan!['idtipo']?.toString() ?? '';
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'plan': _planCtrl.text,
      'correoelectronico': _correoCtrl.text,
      'contrasenia': _contraseniaCtrl.text,
      'idpersona': _idpersonaCtrl.text.isEmpty ? null : int.parse(_idpersonaCtrl.text),
      'idtipo': int.parse(_idtipoCtrl.text),
    };

    setState(() => loading = true);
    try {
      if (widget.plan == null) {
        await ApiPlan.crearPlan(data);
      } else {
        await ApiPlan.actualizarPlan(widget.plan!['id'], data);
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
    final isEdit = widget.plan != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Plan' : 'Nuevo Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _planCtrl,
                decoration: const InputDecoration(labelText: 'Plan'),
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
                child: Text(isEdit ? 'Guardar cambios' : 'Crear plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
