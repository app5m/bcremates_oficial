
import 'global_ws_model.dart';

class City extends GlobalWSModel{
  final String cidade;

  City({
    required this.cidade, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cidade: json['cidade']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}