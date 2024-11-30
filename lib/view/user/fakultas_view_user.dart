import 'package:flutter/material.dart';
import 'package:integrated_odoo/model/fakultas.dart';
import 'package:integrated_odoo/service_api.dart';

class FakultasViewUser extends StatefulWidget {
  const FakultasViewUser({Key? key}) : super(key: key);

  @override
  _FakultasViewState createState() => _FakultasViewState();
}

class _FakultasViewState extends State<FakultasViewUser> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fakultas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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
                                ],
                              ),
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
