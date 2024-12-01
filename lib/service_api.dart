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

  final Map<String, String> statusMapping = {
    'bekerja': 'Bekerja (full time/part time)',
    'wiraswasta': 'Wiraswasta',
    'melanjutkan_pendidikan': 'Melanjutkan Pendidikan',
    'tidak_bekerja': 'Tidak kerja tetapi sedang mencari kerja',
  };

  Future<void> addMahasiswa(Map<String, dynamic> data) async {
    try {
      await auth();
      print('Original data: $data');

      print('Sending data: $data');
      await orpc.callKw({
        'model': 'tracer_alumni.pengguna',
        'method': 'create',
        'args': [data],
        'kwargs': {},
      });
      print('Mahasiswa added successfully');
    } catch (e) {
      print('Error adding mahasiswa: $e');
    }
  }

  Future<void> updateMahasiswa(int id, Map<String, dynamic> data) async {
    try {
      await auth();
      print('Authenticating for updateMahasiswa...');

      // Periksa apakah record dengan ID yang dimaksud ada
      final existing = await orpc.callKw({
        'model': 'tracer_alumni.pengguna',
        'method': 'search',
        'args': [
          [
            ['id', '=', id]
          ]
        ],
        'kwargs': {},
      });

      if (existing.isEmpty) {
        print('No record found with ID: $id');
        return;
      }

      print('Found record with ID: $id. Proceeding with update...');
      print('Data to update: $data');
      print('Type of data: ${data.runtimeType}');

      // Perbarui record
      await orpc.callKw({
        'model': 'tracer_alumni.pengguna',
        'method': 'write',
        'args': [
          [id],
          data,
        ],
        'kwargs': {},
      });
      print('Mahasiswa updated successfully');
    } catch (e) {
      print('Error updating Mahasiswa: $e');
    }
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
