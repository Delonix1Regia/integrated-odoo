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
              return Container(
                color: Colors.lightBlue[50], // Warna latar belakang ListView
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: fakultasList.length,
                  itemBuilder: (context, index) {
                    final fakultas = fakultasList[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.white, // Warna kartu
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fakultas.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Warna teks
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Optional: You can add more info here if needed
                                  // Text("Additional info about the faculty...")
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue), // Warna ikon edit
                                  onPressed: () => _editFakultas(fakultas),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red), // Warna ikon delete
                                  onPressed: () => _deleteFakultas(fakultas.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
