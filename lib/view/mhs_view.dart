import 'package:flutter/material.dart';
import 'package:integrated_odoo/model/mahasiswa.dart';
import 'package:integrated_odoo/model/fakultas.dart';
import 'package:integrated_odoo/model/prodi.dart';
import 'package:integrated_odoo/service_api.dart';

class MhsView extends StatefulWidget {
  @override
  _MhsViewState createState() => _MhsViewState();
}

class _MhsViewState extends State<MhsView> {
  final ServiceApi serviceApi = ServiceApi();
  late Future<List<Mahasiswa>> mahasiswaListFuture;
  late Future<List<Fakultas>> fakultasListFuture;
  late Future<List<Prodi>> prodiListFuture;

  @override
  void initState() {
    super.initState();
    mahasiswaListFuture = fetchMahasiswaList();
    fakultasListFuture = fetchFakultasList();
    prodiListFuture = fetchProdiList();
  }

  Future<List<Mahasiswa>> fetchMahasiswaList() async {
    await serviceApi.auth();
    final getData = await serviceApi.getMhs();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Mahasiswa.fromMap(e)).toList();
  }

  Future<List<Fakultas>> fetchFakultasList() async {
    await serviceApi.auth();
    final getData = await serviceApi.getFakultas();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Fakultas.fromMap(e)).toList();
  }

  Future<List<Prodi>> fetchProdiList() async {
    await serviceApi.auth();
    final getData = await serviceApi.getProdi();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Prodi.fromMap(e)).toList();
  }

  void _refreshData() {
    setState(() {
      mahasiswaListFuture = fetchMahasiswaList();
    });
  }

  Future<void> _addMahasiswa({Map<String, dynamic>? mahasiswa}) async {
    final newMahasiswa = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController(text: mahasiswa?['name']);
        final _nimController = TextEditingController(text: mahasiswa?['nim']);
        final _tahunLulusController =
            TextEditingController(text: mahasiswa?['tahun_lulus']);
        final _noTelpController =
            TextEditingController(text: mahasiswa?['nomor_telepon']);
        final _emailController =
            TextEditingController(text: mahasiswa?['email']);
        final _alamatController =
            TextEditingController(text: mahasiswa?['alamat_rumah']);

        int? selectedFakultasId = mahasiswa?['fakultas_id'];
        int? selectedProdiId = mahasiswa?['prodi_id'];
        String? selectedStatus = mahasiswa?['status'];

        List<String> statusOptions = [
          'Bekerja (full time/part time)',
          'Wiraswasta',
          'Melanjutkan Pendidikan',
          'Tidak kerja tetapi sedang mencari kerja'
        ];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title:
                  Text(mahasiswa != null ? 'Edit Mahasiswa' : 'Add Mahasiswa'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _nimController,
                      decoration: InputDecoration(labelText: 'NIM'),
                    ),
                    TextField(
                      controller: _tahunLulusController,
                      decoration: InputDecoration(labelText: 'Tahun Lulus'),
                    ),
                    TextField(
                      controller: _noTelpController,
                      decoration: InputDecoration(labelText: 'No Telp'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _alamatController,
                      decoration: InputDecoration(labelText: 'Alamat'),
                    ),

                    FutureBuilder<List<Fakultas>>(
                      future: fakultasListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, 
                            children: [
                              Text(
                                'Fakultas',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Container(
                                alignment:
                                    Alignment.centerLeft, 
                                width: MediaQuery.of(context).size.width *
                                    0.8, 
                                child: DropdownButton<int>(
                                  value: selectedFakultasId,
                                  hint: Text('Select Fakultas',
                                      style: TextStyle(fontSize: 16)),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedFakultasId = newValue;
                                    });
                                  },
                                  items: snapshot.data!.map((fakultas) {
                                    return DropdownMenuItem<int>(
                                      value: fakultas.id,
                                      child: Text(fakultas.name,
                                          style: TextStyle(fontSize: 16)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text('No Fakultas available');
                        }
                      },
                    ),

                    FutureBuilder<List<Prodi>>(
                      future: prodiListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, 
                            children: [
                              Text(
                                'Prodi',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Container(
                                alignment:
                                    Alignment.centerLeft, 
                                width: MediaQuery.of(context).size.width *
                                    0.8, 
                                child: DropdownButton<int>(
                                  value: selectedProdiId,
                                  hint: Text('Select Prodi',
                                      style: TextStyle(fontSize: 16)),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedProdiId = newValue;
                                    });
                                  },
                                  items: snapshot.data!.map((prodi) {
                                    return DropdownMenuItem<int>(
                                      value: prodi.id,
                                      child: Text(prodi.name,
                                          style: TextStyle(fontSize: 16)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text('No Prodi available');
                        }
                      },
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey), 
                        ),
                        ...statusOptions.map((status) {
                          return RadioListTile<String>(
                            title: Text(status,
                                style: TextStyle(
                                    fontSize: 16)), 
                            value: status,
                            groupValue: selectedStatus,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStatus = newValue;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newMahasiswaData = {
                      'name': _nameController.text,
                      'nim': _nimController.text,
                      'tahun_lulus': _tahunLulusController.text,
                      'nomor_telepon': _noTelpController.text,
                      'email': _emailController.text,
                      'alamat_rumah': _alamatController.text,
                      'fakultas_id': selectedFakultasId,
                      'prodi_id': selectedProdiId,
                      'status': selectedStatus,
                    };
                    Navigator.pop(context, newMahasiswaData);
                  },
                  child: Text(mahasiswa != null ? 'Update' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (newMahasiswa != null) {
      if (mahasiswa != null) {
        await serviceApi.updateMahasiswa(mahasiswa['id'], newMahasiswa);
      } else {
        await serviceApi.addMahasiswa(newMahasiswa);
      }
      _refreshData();
    }
  }

  Future<void> _deleteMahasiswa(int id) async {
    await serviceApi.deleteMahasiswa(id);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mahasiswa',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () => _addMahasiswa(),
          ),
        ],
      ),
      body: FutureBuilder<List<Mahasiswa>>(
        future: mahasiswaListFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<Mahasiswa>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Mahasiswa>? mahasiswaList = snapshot.data;
            if (mahasiswaList != null && mahasiswaList.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('NIM')),
                    DataColumn(label: Text('Tahun Lulus')),
                    DataColumn(label: Text('No Telp')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Alamat')),
                    DataColumn(label: Text('Fakultas')),
                    DataColumn(label: Text('Prodi')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: mahasiswaList.map((mahasiswa) {
                    return DataRow(cells: [
                      DataCell(Text(mahasiswa.id.toString())),
                      DataCell(Text(mahasiswa.name)),
                      DataCell(Text(mahasiswa.nim)),
                      DataCell(Text(mahasiswa.tahunLulus)),
                      DataCell(Text(mahasiswa.noTelp)),
                      DataCell(Text(mahasiswa.email)),
                      DataCell(Text(mahasiswa.alamat)),
                      DataCell(Text(mahasiswa.fakultasId.toString())),
                      DataCell(Text(mahasiswa.prodiId.toString())),
                      DataCell(Text(mahasiswa.status)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _addMahasiswa(mahasiswa: {
                                'id': mahasiswa.id,
                                'name': mahasiswa.name,
                                'nim': mahasiswa.nim,
                                'tahun_lulus': mahasiswa.tahunLulus,
                                'nomor_telepon': mahasiswa.noTelp,
                                'email': mahasiswa.email,
                                'alamat_rumah': mahasiswa.alamat,
                                'fakultas_id': mahasiswa.fakultasId,
                                'prodi_id': mahasiswa.prodiId,
                                'status': mahasiswa.status,
                              }),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteMahasiswa(mahasiswa.id),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              );
            } else {
              return Center(child: Text('No Mahasiswa available'));
            }
          } else {
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
