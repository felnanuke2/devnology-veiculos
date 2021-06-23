import 'dart:convert';

class VehicleWithDetaillModel {
  final String referencia;
  final String fipeCodigo;
  final String name;
  final String combustivel;
  final String marca;
  final String anoModelo;
  final String preco;
  final String veiculo;
  final String id;
  VehicleWithDetaillModel({
    required this.referencia,
    required this.fipeCodigo,
    required this.name,
    required this.combustivel,
    required this.marca,
    required this.anoModelo,
    required this.preco,
    required this.veiculo,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'referencia': referencia,
      'fipe_codigo': fipeCodigo,
      'name': name,
      'combustivel': combustivel,
      'marca': marca,
      'ano_modelo': anoModelo,
      'preco': preco,
      'veiculo': veiculo,
      'id': id,
    };
  }

  factory VehicleWithDetaillModel.fromMap(Map<String, dynamic> map) {
    return VehicleWithDetaillModel(
      referencia: map['referencia'],
      fipeCodigo: map['fipe_codigo'],
      name: map['name'],
      combustivel: map['combustivel'],
      marca: map['marca'],
      anoModelo: map['ano_modelo'] == '32000' ? 'Zero Km' : map['ano_modelo'],
      preco: map['preco'],
      veiculo: map['veiculo'],
      id: map['id'],
    );
  }
}
