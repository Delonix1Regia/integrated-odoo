class Mahasiswa {
  final int id;
  final String name;
  final String nim;
  final String tahunLulus;
  final String noTelp;
  final String email;
  final String alamat;
  final int fakultasId; // Fakultas ID
  final int prodiId; // Prodi ID
  final String status; // Status mahasiswa

  Mahasiswa({
    required this.id,
    required this.name,
    required this.nim,
    required this.tahunLulus,
    required this.noTelp,
    required this.email,
    required this.alamat,
    required this.fakultasId,
    required this.prodiId,
    required this.status,
  });

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    T? getListValue<T>(dynamic list) =>
        list is List && list.isNotEmpty ? list[0] : null;

    return Mahasiswa(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      nim: map['nim'] ?? '',
      tahunLulus: map['tahun_lulus']?.toString() ?? '',
      noTelp: map['nomor_telepon'] ?? '',
      email: map['email'] ?? '',
      alamat: map['alamat_rumah'] ?? '',
      fakultasId: getListValue<int>(map['fakultas_id']) ?? 0,
      prodiId: getListValue<int>(map['prodi_id']) ?? 0,
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nim': nim,
      'tahun_lulus': tahunLulus,
      'nomor_telepon': noTelp,
      'email': email,
      'alamat_rumah': alamat,
      'fakultas_id': fakultasId,
      'prodi_id': prodiId,
      'status': status,
    };
  }
}
