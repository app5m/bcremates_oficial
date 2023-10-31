
import 'global_ws_model.dart';

class Auction extends GlobalWSModel{
  final String descricao;
  final String nome;
  final String url;

  Auction({
    required this.descricao,
    required this.nome,
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      url: json['url']?? "",
      nome: json['nome']?? "",
      descricao: json['descricao']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}