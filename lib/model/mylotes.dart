class MyLotes {
  int? idLance;
  int? idLeilao;
  int? idLote;
  String? dataLance;
  int? statusLance;
  List<StatusVencedor>? statusVencedor;
  String? pesoLote;
  String? valorLance;
  String? numeroLote;
  int? qtdAnimais;
  String? racaoPelo;
  String? vendedor;
  String? urlLote;
  int? statusLote;
  String? nomeLeilao;
  String? cidadeLeilao;
  String? estadoLeilao;
  int? statusLeilao;
  String? nomeCategoria;
  String? descricaoCategoria;
  String? urlCategoria;
  int? rows;

  MyLotes(
      {this.idLance,
        this.idLeilao,
        this.idLote,
        this.dataLance,
        this.statusLance,
        this.statusVencedor,
        this.pesoLote,
        this.valorLance,
        this.numeroLote,
        this.qtdAnimais,
        this.racaoPelo,
        this.vendedor,
        this.urlLote,
        this.statusLote,
        this.nomeLeilao,
        this.cidadeLeilao,
        this.estadoLeilao,
        this.statusLeilao,
        this.nomeCategoria,
        this.descricaoCategoria,
        this.urlCategoria,
        this.rows});

  MyLotes.fromJson(Map<String, dynamic> json) {
    idLance = json['id_lance'];
    idLeilao = json['id_leilao'];
    idLote = json['id_lote'];
    dataLance = json['data_lance'];
    statusLance = json['status_lance'];
    if (json['status_vencedor'] != null) {
      statusVencedor = <StatusVencedor>[];
      json['status_vencedor'].forEach((v) {
        statusVencedor!.add(new StatusVencedor.fromJson(v));
      });
    }
    pesoLote = json['peso_lote'];
    valorLance = json['valor_lance'];
    numeroLote = json['numero_lote'];
    qtdAnimais = json['qtd_animais'];
    racaoPelo = json['racao_pelo'];
    vendedor = json['vendedor'];
    urlLote = json['url_lote'];
    statusLote = json['status_lote'];
    nomeLeilao = json['nome_leilao'];
    cidadeLeilao = json['cidade_leilao'];
    estadoLeilao = json['estado_leilao'];
    statusLeilao = json['status_leilao'];
    nomeCategoria = json['nome_categoria'];
    descricaoCategoria = json['descricao_categoria'];
    urlCategoria = json['url_categoria'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_lance'] = this.idLance;
    data['id_leilao'] = this.idLeilao;
    data['id_lote'] = this.idLote;
    data['data_lance'] = this.dataLance;
    data['status_lance'] = this.statusLance;
    if (this.statusVencedor != null) {
      data['status_vencedor'] =
          this.statusVencedor!.map((v) => v.toJson()).toList();
    }
    data['peso_lote'] = this.pesoLote;
    data['valor_lance'] = this.valorLance;
    data['numero_lote'] = this.numeroLote;
    data['qtd_animais'] = this.qtdAnimais;
    data['racao_pelo'] = this.racaoPelo;
    data['vendedor'] = this.vendedor;
    data['url_lote'] = this.urlLote;
    data['status_lote'] = this.statusLote;
    data['nome_leilao'] = this.nomeLeilao;
    data['cidade_leilao'] = this.cidadeLeilao;
    data['estado_leilao'] = this.estadoLeilao;
    data['status_leilao'] = this.statusLeilao;
    data['nome_categoria'] = this.nomeCategoria;
    data['descricao_categoria'] = this.descricaoCategoria;
    data['url_categoria'] = this.urlCategoria;
    data['rows'] = this.rows;
    return data;
  }
}

class StatusVencedor {
  String? valorDado;
  String? status;

  StatusVencedor({this.valorDado, this.status});

  StatusVencedor.fromJson(Map<String, dynamic> json) {
    valorDado = json['valor_dado'];
    status = json['status_leilao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valor_dado'] = this.valorDado;
    data['status_leilao'] = this.status;
    return data;
  }
}