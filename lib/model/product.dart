
import 'global_ws_model.dart';

class Product extends GlobalWSModel{
  final String url;
  final String nome;
  final String nome_produto;
  final String codigo_produto;
  final String foto;

  Product({
    required this.url,
    required this.nome,
    required this.nome_produto,
    required this.codigo_produto,
    required this.foto, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      url: json['url']?? "",
      nome: json['nome']?? "",
      nome_produto: json['nome_produto']?? "",
      codigo_produto: json['codigo_produto']?? "",
      foto: json['foto']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}