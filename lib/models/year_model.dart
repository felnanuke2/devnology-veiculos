class YearModel {
  final String? fipeMarca;
  final String fipeCodigo;
  final String name;
  final String? marca;
  final String key;
  final String? veiculo;
  final String id;

  YearModel({
    required this.fipeMarca,
    required this.fipeCodigo,
    required this.name,
    required this.marca,
    required this.key,
    required this.veiculo,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'fipe_marca': fipeMarca,
      'fipe_codigo': fipeCodigo,
      'name': name,
      'marca': marca,
      'key': key,
      'veiculo': veiculo,
      'id': id,
    };
  }

  factory YearModel.fromMap(Map<String, dynamic> map) {
    var splited = map['key'].toString().split('-');
    var key = splited[0];
    return YearModel(
      fipeMarca: map['fipe_marca'],
      fipeCodigo: map['fipe_codigo'],
      name: map['name'],
      marca: map['marca'],
      key: key == '32000' ? 'Zero KM' : key,
      veiculo: map['veiculo'],
      id: map['id'],
    );
  }
}
