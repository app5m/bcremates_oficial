class Lotes {
  String? numeroLote;
  int? idLote;
  int? idLeilao;
  String? maiorLance;
  int? qtdAnimais;
  String? peso;
  int? idCategoria;
  String? categoriaLeilao;
  String? categoriaLote;
  String? racaoPelo;
  String? vendedorLote;
  String? urlLote;
  int? statusLote;
  String? nomeLeilao;
  String? cidadeLeilao;
  String? estadoLeilao;
  String? dataCadastro;
  int? statusLeilao;
  String? nomeCategoria;
  String? urlCategoria;
  String? descricaoCategoria;
  int? rows;

  Lotes(
      {this.numeroLote,
        this.idLote,
        this.idLeilao,
        this.maiorLance,
        this.qtdAnimais,
        this.peso,
        this.idCategoria,
        this.categoriaLeilao,
        this.categoriaLote,
        this.racaoPelo,
        this.vendedorLote,
        this.urlLote,
        this.statusLote,
        this.nomeLeilao,
        this.cidadeLeilao,
        this.estadoLeilao,
        this.dataCadastro,
        this.statusLeilao,
        this.nomeCategoria,
        this.urlCategoria,
        this.descricaoCategoria,
        this.rows});

  Lotes.fromJson(Map<String, dynamic> json) {
    numeroLote = json['numero_lote'];
    idLote = json['id_lote'];
    idLeilao = json['id_leilao'];
    maiorLance = json['maior_lance'];
    qtdAnimais = json['qtd_animais'];
    peso = json['peso'];
    idCategoria = json['id_categoria'];
    categoriaLeilao = json['categoria_leilao'];
    categoriaLote = json['categoria_lote'];
    racaoPelo = json['racao_pelo'];
    vendedorLote = json['vendedor_lote'];
    urlLote = json['url_lote'];
    statusLote = json['status_lote'];
    nomeLeilao = json['nome_leilao'];
    cidadeLeilao = json['cidade_leilao'];
    estadoLeilao = json['estado_leilao'];
    dataCadastro = json['data_cadastro'];
    statusLeilao = json['status_leilao'];
    nomeCategoria = json['nome_categoria'];
    urlCategoria = json['url_categoria'];
    descricaoCategoria = json['descricao_categoria'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero_lote'] = this.numeroLote;
    data['id_lote'] = this.idLote;
    data['id_leilao'] = this.idLeilao;
    data['maior_lance'] = this.maiorLance;
    data['qtd_animais'] = this.qtdAnimais;
    data['peso'] = this.peso;
    data['id_categoria'] = this.idCategoria;
    data['categoria_leilao'] = this.categoriaLeilao;
    data['categoria_lote'] = this.categoriaLote;
    data['racao_pelo'] = this.racaoPelo;
    data['vendedor_lote'] = this.vendedorLote;
    data['url_lote'] = this.urlLote;
    data['status_lote'] = this.statusLote;
    data['nome_leilao'] = this.nomeLeilao;
    data['cidade_leilao'] = this.cidadeLeilao;
    data['estado_leilao'] = this.estadoLeilao;
    data['data_cadastro'] = this.dataCadastro;
    data['status_leilao'] = this.statusLeilao;
    data['nome_categoria'] = this.nomeCategoria;
    data['url_categoria'] = this.urlCategoria;
    data['descricao_categoria'] = this.descricaoCategoria;
    data['rows'] = this.rows;
    return data;
  }
}


