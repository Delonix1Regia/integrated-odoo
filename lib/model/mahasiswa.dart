class Mahasiswa {
  final int id;
  final String name;
  final String nim;
  final String tahunLulus;
  final String noTelp;
  final String email;
  final String alamat;
  final int fakultasId; // Add Fakultas ID
  final int prodiId; // Add Prodi ID
  // final int agamaId;    // Add Agama ID
  final String status; // Add Status

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
    // required this.agamaId,     
    required this.status, 
  });

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
  return Mahasiswa(
    id: map['id'] ?? 0, 
    name: map['name'] ?? '', 
    nim: map['nim'] ?? '',
    tahunLulus: map['tahun_lulus']?.toString() ?? '', 
    noTelp: map['nomor_telepon'] ?? '',
    email: map['email'] ?? '',
    alamat: map['alamat_rumah'] ?? '',
    fakultasId: (map['fakultas_id'] != null && map['fakultas_id'] is List && map['fakultas_id'].isNotEmpty) 
                ? map['fakultas_id'][0] ?? 0 : 0, 
    prodiId: (map['prodi_id'] != null && map['prodi_id'] is List && map['prodi_id'].isNotEmpty) 
             ? map['prodi_id'][0] ?? 0 : 0, 
    // agamaId: (map['agama_id'] != null && map['agama_id'] is List && map['agama_id'].isNotEmpty) 
    //          ? map['agama_id'][0] ?? 0 : 0,
    status: map['status'] ?? '', 
  );
}

}
