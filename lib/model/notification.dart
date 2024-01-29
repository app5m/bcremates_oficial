class NotificationPop {
  final int? id;
  final String? title;
  final String? description;
  final String? date;
  final String? type;
  final String? idAnuncio;

  NotificationPop({this.id, this.title, this.description, this.date, this.type, this.idAnuncio,});

  factory NotificationPop.fromJson(Map<String, dynamic> json) {
    return NotificationPop(
      id: json['id'],
      title: json['titulo'],
      description: json['descricao'],
      type: json['type'],
      date: json['data'],
      idAnuncio: json['id_anuncio'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': title,
      'descricao': description,
      'type': type,
      'data': date,
      'id_anuncio': idAnuncio,
    };
  }
  @override
  String toString() {
    return 'NotificationIOSModel{id: $id, type: $type, idAnuncio: $idAnuncio, title $title, description $description,}';
  }

}