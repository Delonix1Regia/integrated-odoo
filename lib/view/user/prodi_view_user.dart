import 'package:flutter/material.dart';
import 'package:integrated_odoo/model/prodi.dart';
import 'package:integrated_odoo/service_api.dart';

class ProdiViewUser extends StatefulWidget {
  const ProdiViewUser({super.key});

  @override
  _ProdiViewState createState() => _ProdiViewState();
}

class _ProdiViewState extends State<ProdiViewUser> {
  final ServiceApi serviceApi = ServiceApi();
  late Future<List<Prodi>> futureProdiList;

  @override
  void initState() {
    super.initState();
    futureProdiList = fetchProdiList();
  }

  Future<List<Prodi>> fetchProdiList() async {
    await serviceApi.auth();
    final getData = await serviceApi.getProdi();
    final List<dynamic> getDataList = getData as List<dynamic>;
    return getDataList.map((e) => Prodi.fromMap(e)).toList();
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
              return Container(
                color: Colors.lightBlue[50], // Warna latar belakang ListView
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: prodiList.length,
                  itemBuilder: (context, index) {
                    final prodi = prodiList[index];
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
                                    prodi.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Warna teks
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Fakultas: ${prodi.fakultasName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey, // Warna teks fakultas
                                    ),
                                  ),
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
