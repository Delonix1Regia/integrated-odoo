import 'package:flutter/material.dart';
import 'package:integrated_odoo/model/mahasiswa.dart';
import 'package:integrated_odoo/model/fakultas.dart';
import 'package:integrated_odoo/model/prodi.dart';
import 'package:integrated_odoo/service_api.dart';

class MhsViewUser extends StatefulWidget {
  @override
  _MhsViewState createState() => _MhsViewState();
}

class _MhsViewState extends State<MhsViewUser> {
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

        // Tambahkan deklarasi statusOptions di sini
        final List<String> statusOptions = [
          'Bekerja (full time/part time)',
          'Wiraswasta',
          'Melanjutkan Pendidikan',
          'Tidak kerja tetapi sedang mencari kerja',
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fakultas',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width * 0.8,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prodi',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width * 0.8,
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
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        ...statusOptions.map((status) {
                          return RadioListTile<String>(
                            title: Text(status, style: TextStyle(fontSize: 16)),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mahasiswa',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => _addMahasiswa(),
          ),
        ],
      ),
      body: FutureBuilder<List<Mahasiswa>>(
        future: mahasiswaListFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<Mahasiswa>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Mahasiswa>? mahasiswaList = snapshot.data;
            if (mahasiswaList != null && mahasiswaList.isNotEmpty) {
              return Container(
                color: Colors.lightBlue[50], // Background color of ListView
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: mahasiswaList.length,
                  itemBuilder: (context, index) {
                    final mahasiswa = mahasiswaList[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.white, // Card color
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mahasiswa.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Text color
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('NIM: ${mahasiswa.nim}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      )),
                                  // Optional: You can add more info here if needed
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue), // Edit icon color
                                  onPressed: () => _addMahasiswa(
                                      mahasiswa: mahasiswa.toMap()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red), // Delete icon color
                                  onPressed: () =>
                                      _deleteMahasiswa(mahasiswa.id),
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
