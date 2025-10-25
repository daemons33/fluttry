import 'package:flutter/material.dart';
import 'package:hw/features/plan/controllers/api_plan.dart'; // ajusta el import según tu estructura
import 'package:hw/features/plan/pages/plan_form_page.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  bool loading = false;
  List<dynamic> planes = [];

  @override
  void initState() {
    super.initState();
    _loadPlanes();
  }

  Future<void> _loadPlanes() async {
    setState(() => loading = true);
    try {
      final res = await ApiPlan.getPlanes();
      setState(() => planes = res);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _eliminarPlan(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Seguro que deseas eliminar este plan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      await ApiPlan.eliminarPlan(id);
      _loadPlanes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlanFormPage()),
              );
              _loadPlanes();
            },
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : planes.isEmpty
          ? const Center(child: Text('No hay planes'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Plan')),
            DataColumn(label: Text('Correo')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: planes.map((u) {
            return DataRow(cells: [
              DataCell(Text(u['id'].toString())),
              DataCell(Text(u['descripcion'] ?? '')),
              DataCell(Text(u['correoelectronico'] ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlanFormPage(plan: u),
                        ),
                      );
                      _loadPlanes();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarPlan(u['id']),
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