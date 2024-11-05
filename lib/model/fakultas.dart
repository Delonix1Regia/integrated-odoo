class Fakultas {
  final int id;
  final String name;

  Fakultas({required this.id, required this.name});

  factory Fakultas.fromMap(Map<String,dynamic> map){
    return Fakultas(id: map['id'], name: map['name']);
  }
}