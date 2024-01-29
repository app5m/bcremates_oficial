class Leilao {
  int? id;
  String? nomeLeilao;
  int? quantidadeLotes;
  String? cidadeLeilao;
  String? estadoLeilao;
  String? nomeCategoria;
  String? urlCategoria;
  String? descricaoCategoria;
  String? dataInicio;
  String? hora;
  String? urlLeilao;
  int? status;
  int? statusParticipante;
  int? rows;

  Leilao(
      {this.id,
        this.nomeLeilao,
        this.quantidadeLotes,
        this.cidadeLeilao,
        this.estadoLeilao,
        this.nomeCategoria,
        this.urlCategoria,
        this.descricaoCategoria,
        this.dataInicio,
        this.urlLeilao,
        this.hora,
        this.status,
        this.statusParticipante,
        this.rows});

  Leilao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomeLeilao = json['nome_leilao'];
    quantidadeLotes = json['quantidade_lotes'];
    cidadeLeilao = json['cidade_leilao'];
    estadoLeilao = json['estado_leilao'];
    nomeCategoria = json['nome_categoria'];
    urlCategoria = json['url_categoria'];
    descricaoCategoria = json['descricao_categoria'];
    dataInicio = json['data'];
    urlLeilao = json['url_leilao'];
    hora = json['horario'];
    status = json['status'];
    statusParticipante = json['status_participante'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome_leilao'] = this.nomeLeilao;
    data['quantidade_lotes'] = this.quantidadeLotes;
    data['cidade_leilao'] = this.cidadeLeilao;
    data['estado_leilao'] = this.estadoLeilao;
    data['nome_categoria'] = this.nomeCategoria;
    data['url_categoria'] = this.urlCategoria;
    data['descricao_categoria'] = this.descricaoCategoria;
    data['data_inicio'] = this.dataInicio;
    data['url_leilao'] = this.urlLeilao;
    data['status'] = this.status;
    data['rows'] = this.rows;
    return data;
  }
}

