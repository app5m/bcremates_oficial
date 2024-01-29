class Banners {
  int? id;
  String? nome;
  String? link;
  String? url;
  int? status;
  int? ordem;
  int? rows;

  Banners(
      {this.id,
        this.nome,
        this.link,
        this.url,
        this.status,
        this.ordem,
        this.rows});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    link = json['link'];
    url = json['url'];
    status = json['status'];
    ordem = json['ordem'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['link'] = this.link;
    data['url'] = this.url;
    data['status'] = this.status;
    data['ordem'] = this.ordem;
    data['rows'] = this.rows;
    return data;
  }
}