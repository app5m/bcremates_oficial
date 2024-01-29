class Category {
  int? id;
  String? nome;
  String? descricao;
  String? url;
  bool selecionado = false;

  Category({this.id, this.nome, this.descricao, this.url, this.selecionado = false});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['url'] = this.url;
    return data;
  }
}
