class MarcaModel {
  final String name;
  final String fipeName;
  final int order;
  final String key;
  final int id;
  MarcaModel({
    required this.name,
    required this.fipeName,
    required this.order,
    required this.key,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fipe_name': fipeName,
      'order': order,
      'key': key,
      'id': id,
    };
  }

  factory MarcaModel.fromMap(Map<String, dynamic> map) {
    return MarcaModel(
      name: map['name'],
      fipeName: map['fipe_name'],
      order: map['order'],
      key: map['key'],
      id: map['id'],
    );
  }
}
