class NotificationIOSModel {
  Aps? aps;
  String? type;
  String? idAnuncio;
  String? vibrate;
  String? sound;
  String? data;

  NotificationIOSModel(
      {this.aps, this.type, this.idAnuncio, this.vibrate, this.sound, this.data});

  NotificationIOSModel.fromJson(Map<String, dynamic> json) {
    aps = json['aps'] != null ? new Aps.fromJson(json['aps']) : null;
    type = json['type'];
    idAnuncio = json['id_anuncio'];
    vibrate = json['vibrate'];
    sound = json['sound'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aps != null) {
      data['aps'] = this.aps!.toJson();
    }
    data['type'] = this.type;
    data['id_anuncio'] = this.idAnuncio;
    data['vibrate'] = this.vibrate;
    data['sound'] = this.sound;
    data['data'] = this.data;
    return data;
  }

  @override
  String toString() {
    return 'NotificationIOSModel{aps: $aps, type: $type, idAnuncio: $idAnuncio, vibrate: $vibrate, sound: $sound, data: $data}';
  }
}

class Aps {
  Alert? alert;
  String? sound;
  int? badge;

  Aps({this.alert, this.sound, this.badge});

  Aps.fromJson(Map<String, dynamic> json) {
    alert = json['alert'] != null ? new Alert.fromJson(json['alert']) : null;
    sound = json['sound'];
    badge = json['badge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alert != null) {
      data['alert'] = this.alert!.toJson();
    }
    data['sound'] = this.sound;
    data['badge'] = this.badge;
    return data;
  }
  @override
  String toString() {
    return 'Aps{alert: $alert, sound: $sound, badge: $badge}';
  }
}

class Alert {
  String? title;
  String? body;

  Alert({this.title, this.body});

  Alert.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
  @override
  String toString() {
    return 'Alert{title: $title, body: $body}';
  }
}


