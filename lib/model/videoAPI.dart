class VideoAPI {
  int? id;
  String? live;
  String? linkCortado;
  String? whatsapp;

  VideoAPI({this.id, this.live, this.linkCortado, this.whatsapp});

  VideoAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    live = json['live'];
    linkCortado = json['link_cortado'];
    whatsapp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['live'] = this.live;
    data['link_cortado'] = this.linkCortado;
    data['whatsapp'] = this.whatsapp;
    return data;
  }
}