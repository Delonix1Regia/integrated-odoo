import 'package:odoo_rpc/odoo_rpc.dart';

class ServiceApi {
  final orpc = OdooClient('http://192.168.56.1:10017');

  Future<void> auth() async {
    try {
      await orpc.authenticate(
          'TracerAlumni', 'diahayu18837@gmail.com', 'diah123');
      final res = await orpc.callRPC('/web/session/modules', 'call', {});
      print('Installed modules : ${res.toString()}');
    } on OdooException catch (e) {
      print(e);
      orpc.close();
    }
  }

  Future<dynamic> getProdi() async {
    await auth();
    return orpc.callKw({
      'model': 'tracer_alumni.prodi',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'fakultas_id'],
        'limit': 80,
      },
    });
  }

  Future<void> addProdi(Map<String, dynamic> prodiData) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.prodi',
      'method': 'create',
      'args': [prodiData],
      'kwargs': {},
    });
  }

  Future<void> updateProdi(int id, Map<String, dynamic> data) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.prodi',
      'method': 'write',
      'args': [
        [id],
        data,
      ],
      'kwargs': {},
    });
  }

  Future<void> deleteProdi(int id) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.prodi',
      'method': 'unlink',
      'args': [
        [id],
      ],
      'kwargs': {},
    });
  }

  Future<dynamic> getFakultas() async {
    await auth();
    return orpc.callKw({
      'model': 'tracer_alumni.fakultas',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name'],
        'limit': 80,
      },
    });
  }

  Future<void> addFakultas(Map<String, dynamic> fakultasData) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.fakultas',
      'method': 'create',
      'args': [fakultasData],
      'kwargs': {}, 
    });
  }

  Future<void> updateFakultas(int id, Map<String, dynamic> data) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.fakultas',
      'method': 'write',
      'args': [
        [id],
        data,
      ],
      'kwargs': {}, 
    });
  }

  Future<void> deleteFakultas(int id) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.fakultas',
      'method': 'unlink',
      'args': [
        [id],
      ],
      'kwargs': {}, 
    });
  }

  Future<dynamic> getMhs() async {
    await auth();
    return orpc.callKw({
      'model': 'tracer_alumni.pengguna',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': [
          'id',
          'name',
          'nim',
          'tahun_lulus',
          'email',
          'nomor_telepon',
          'alamat_rumah',
          'fakultas_id',
          'prodi_id',
          'status'
        ],
        'limit': 80,
      },
    });
  }

  Future<void> addMahasiswa(Map<String, dynamic> mahasiswaData) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.pengguna',
      'method': 'create',
      'args': [mahasiswaData],
      'kwargs': {}, 
    });
  }

  Future<void> updateMahasiswa(int id, Map<String, dynamic> data) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.pengguna',
      'method': 'write',
      'args': [
        [id],
        data,
      ],
      'kwargs': {}, 
    });
  }

  Future<void> deleteMahasiswa(int id) async {
    await auth();
    await orpc.callKw({
      'model': 'tracer_alumni.pengguna',
      'method': 'unlink',
      'args': [
        [id],
      ],
      'kwargs': {}, 
    });
  }
}
