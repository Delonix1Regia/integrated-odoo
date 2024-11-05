import 'package:flutter/material.dart';
import 'package:integrated_odoo/model/prodi.dart';
import 'package:integrated_odoo/model/fakultas.dart';
import 'package:integrated_odoo/service_api.dart';

class ProdiView extends StatefulWidget {
  const ProdiView({super.key});

  @override
  _ProdiViewState createState() => _ProdiViewState();
}

class _ProdiViewState extends State<ProdiView> {
  final ServiceApi serviceApi = ServiceApi();
  late Future<List<Prodi>> futureProdiList;
  late Future<List<Fakultas>> futureFakultasList;
  int? selectedFakultasId;

  @override
  void initState() {
    super.initState();
    futureProdiList = fetchProdiList();
    futureFakultasList = fetchFakultasList();
  }

  Future<List<Prodi>> fetchProdiList() async {
    await serviceApi.auth();
    final getData = await serviceApi.getProdi();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Prodi.fromMap(e)).toList();
  }

  Future<List<Fakultas>> fetchFakultasList() async {
    await serviceApi.auth();
    final getData = await serviceApi.getFakultas();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Fakultas.fromMap(e)).toList();
  }

  Future<void> addProdi(String name, int fakultasId) async {
    final Map<String, dynamic> prodiData = {
      'name': name,
      'fakultas_id': fakultasId,
    };
    await serviceApi.addProdi(prodiData);
    setState(() {
      futureProdiList = fetchProdiList();
    });
  }

  Future<void> deleteProdi(int id) async {
    await serviceApi.deleteProdi(id);
    setState(() {
      futureProdiList = fetchProdiList();
    });
  }

  void _showProdiDialog({Prodi? prodi}) async {
    final fakultasList = await futureFakultasList;
    String name = prodi?.name ?? '';
    selectedFakultasId = prodi?.fakultasId;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(prodi == null ? 'Add Prodi' : 'Edit Prodi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => name = value,
                    controller: TextEditingController(text: name),
                    decoration: const InputDecoration(hintText: 'Prodi Name'),
                  ),
                  FutureBuilder<List<Fakultas>>(
                    future: futureFakultasList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fakultas',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: DropdownButton<int>(
                                value: selectedFakultasId,
                                hint: const Text(
                                  'Select Fakultas',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedFakultasId = newValue;
                                  });
                                },
                                items: snapshot.data!.map((fakultas) {
                                  return DropdownMenuItem<int>(
                                    value: fakultas.id,
                                    child: Text(
                                      fakultas.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('No Fakultas available');
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (name.isNotEmpty && selectedFakultasId != null) {
                      if (prodi == null) {
                        await addProdi(name, selectedFakultasId!);
                      }
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prodi',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white, 
        actions: [
          IconButton(
            icon: const Icon(Icons.add,
                color: Colors.black), 
            onPressed: () => _showProdiDialog(),
          ),
        ],
      ),
      body: FutureBuilder<List<Prodi>>(
        future: futureProdiList,
        builder: (BuildContext context, AsyncSnapshot<List<Prodi>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Prodi>? prodiList = snapshot.data;
            if (prodiList != null && prodiList.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Fakultas')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: prodiList.map((prodi) {
                    return DataRow(
                      cells: [
                        DataCell(Text(prodi.id.toString())),
                        DataCell(Text(prodi.name)),
                        DataCell(Text(prodi.fakultasName)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showProdiDialog(prodi: prodi),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteProdi(prodi.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
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
