class Prodi {
  final int id;
  final String name;
  final int fakultasId;
  final String fakultasName;

  Prodi({
    required this.id,
    required this.name,
    required this.fakultasId,
    required this.fakultasName,
  });

  factory Prodi.fromMap(Map<String, dynamic> map) {
    return Prodi(
      id: map['id'],
      name: map['name'],
      fakultasId: map['fakultas_id'][0],
      fakultasName: map['fakultas_id'][1],
    );
  }
}
