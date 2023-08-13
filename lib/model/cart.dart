import 'global_ws_model.dart';

class Cart extends GlobalWSModel{
  int qtd_atual;
  int qtd_minima;
  dynamic valor_minimo;
  String total;
  dynamic valor_minimo_2;
  dynamic total_2;
  dynamic carrinho_aberto;
  List<dynamic> itens;

  Cart({required this.valor_minimo,
    required this.total,
    required this.carrinho_aberto,
    required this.itens,
    required this.qtd_minima,
    required this.qtd_atual,
    required this.valor_minimo_2,
    required this.total_2, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      total: json['total'],
      valor_minimo: json['valor_minimo'],
      itens: json['itens'],
      qtd_minima: json['qtd_minima'],
      qtd_atual: json['qtd_atual'],
      carrinho_aberto: json['carrinho_aberto'],
      valor_minimo_2: json['valor_minimo_2'],
      total_2: json['total_2'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'id': id,
      'rows': rows,
    };
  }
}