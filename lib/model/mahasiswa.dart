class Mahasiswa {
  final int id;
  final String name;
  final String nim;
  final String tahunLulus;
  final String noTelp;
  final String email;
  final String alamat;
  final int fakultasId;
  final int prodiId;
  final String status;

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

  // Factory untuk membuat objek dari Map
  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: 1,
      name: "Ahmad Fauzi",
      nim: "12345678",
      tahunLulus: "2022",
      noTelp: "081234567890",
      email: "ahmad.fauzi@example.com",
      alamat: "Jl. Raya Malang No. 1",
      fakultasId: 1,
      prodiId: 101,
      status: "Bekerja (full time)",
    );
  }

  // Convert object to Map
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
