import 'package:flutter/material.dart';
import 'package:integrated_odoo/model/fakultas.dart';
import 'package:integrated_odoo/service_api.dart';

class FakultasView extends StatefulWidget {
  const FakultasView({Key? key}) : super(key: key);

  @override
  _FakultasViewState createState() => _FakultasViewState();
}

class _FakultasViewState extends State<FakultasView> {
  final ServiceApi serviceApi = ServiceApi();
  late Future<List<Fakultas>> fakultasListFuture;

  @override
  void initState() {
    super.initState();
    fakultasListFuture = fetchFakultasList();
  }

  Future<List<Fakultas>> fetchFakultasList() async {
    await serviceApi.auth(); 
    final getData = await serviceApi.getFakultas();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Fakultas.fromMap(e)).toList();
  }

  void _refreshData() {
    setState(() {
      fakultasListFuture = fetchFakultasList();
    });
  }

  Future<void> _addFakultas() async {
    final newFakultas = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController();

        return AlertDialog(
          title: Text('Add Fakultas'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Fakultas Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newFakultasData = {
                  'name': _nameController.text,
                };
                Navigator.pop(context, newFakultasData);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newFakultas != null) {
      await serviceApi.addFakultas(newFakultas);
      _refreshData();
    }
  }

  Future<void> _deleteFakultas(int id) async {
    await serviceApi.deleteFakultas(id);
    _refreshData();
  }

  Future<void> _editFakultas(Fakultas fakultas) async {
    final updatedFakultas = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController(text: fakultas.name);

        return AlertDialog(
          title: Text('Edit Fakultas'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Fakultas Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedData = {
                  'name': _nameController.text,
                };
                Navigator.pop(context, updatedData);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedFakultas != null) {
      await serviceApi.updateFakultas(fakultas.id, updatedFakultas);
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fakultas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white, 
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: _addFakultas,
          ),
        ],
      ),
      body: FutureBuilder<List<Fakultas>>(
        future: fakultasListFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<Fakultas>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Fakultas>? fakultasList = snapshot.data;
            if (fakultasList != null && fakultasList.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Actions')), 
                  ],
                  rows: fakultasList.map((fakultas) {
                    return DataRow(cells: [
                      DataCell(Text(fakultas.id.toString())),
                      DataCell(Text(fakultas.name)),
                      DataCell(
                        Container(
                          width: 150, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly, 
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editFakultas(fakultas),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteFakultas(fakultas.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
