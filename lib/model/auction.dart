
import 'global_ws_model.dart';

class Auction extends GlobalWSModel{
  final String descricao;
  final String nome;
  final String url;
  final String nome_leilao;
  final String quantidade_lotes;
  final String cidade_leilao;
  final String estado_leilao;
  final String nome_categoria;
  final String url_categoria;
  final String descricao_categoria;
  final String data_cadastro;

  final String id_lote;
  final String id_leilao;
  final String maior_lance;
  final String qtd_animais;
  final String peso;
  final String id_categoria;
  final String categoria_leilao;
  final String categoria_lote;
  final String racao_pelo;
  final String vendedor_lote;
  final String url_lote;
  final String numero_lote;
  final String status_lote;
  final String status_leilao;

  Auction({
    required this.descricao,
    required this.nome,
    required this.url,
    required this.nome_leilao,
    required this.quantidade_lotes,
    required this.cidade_leilao,
    required this.estado_leilao,
    required this.nome_categoria,
    required this.url_categoria,
    required this.descricao_categoria,
    required this.data_cadastro,
    required this.id_lote,
    required this.id_leilao,
    required this.maior_lance,
    required this.qtd_animais,
    required this.peso,
    required this.id_categoria,
    required this.categoria_leilao,
    required this.categoria_lote,
    required this.racao_pelo,
    required this.vendedor_lote,
    required this.url_lote,
    required this.numero_lote,
    required this.status_lote,
    required this.status_leilao,
    required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      data_cadastro: json['data_cadastro']?? "",
      descricao_categoria: json['descricao_categoria']?? "",
      url_categoria: json['url_categoria']?? "",
      nome_categoria: json['nome_categoria']?? "",
      estado_leilao: json['estado_leilao']?? "",
      cidade_leilao: json['cidade_leilao']?? "",
      quantidade_lotes: json['quantidade_lotes']?? "",
      nome_leilao: json['nome_leilao']?? "",
      url: json['url']?? "",
      nome: json['nome']?? "",
      descricao: json['descricao']?? "",
      id_lote: json['id_lote']?? "",
      id_leilao: json['id_leilao']?? "",
      maior_lance: json['maior_lance']?? "",
      qtd_animais: json['qtd_animais']?? "",
      peso: json['peso']?? "",
      id_categoria: json['id_categoria']?? "",
      categoria_leilao: json['categoria_leilao']?? "",
      categoria_lote: json['categoria_lote']?? "",
      racao_pelo: json['racao_pelo']?? "",
      vendedor_lote: json['vendedor_lote']?? "",
      url_lote: json['url_lote']?? "",
      numero_lote: json['numero_lote']?? "",
      status_lote: json['status_lote']?? "",
      status_leilao: json['status_leilao']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}