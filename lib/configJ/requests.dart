import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestsWebServices {
  final String urlBase;

  RequestsWebServices(this.urlBase);

  Future<Map<String, dynamic>> sendPhotosAd(String urlResquet, String token, List<File> files, int idAnuncio) async {
    try {
      final url = Uri.parse(urlBase + urlResquet);

      final request = http.MultipartRequest('POST', url);

      request.fields['id_anuncio'] = idAnuncio.toString();
      request.fields['token'] = token;

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        request.files.add(await http.MultipartFile.fromPath('url[$i]', file.path));

      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print('Conteúdo do corpo da requisição: ${request.fields}');
      print(url);
      print(responseString + " " + response.statusCode.toString());

      if (response.statusCode == 200) {
        final responseBody = json.decode(responseString);
        return responseBody;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
      throw Exception('Erro durante a requisição: $e');
    }
  }


  Future<List<dynamic>>  sendMessage(
      String urlResquet,
      String token,
      int idDe,
      int idPara,
      int type,
      String mensagem,
      List<File> files,
      int idAnuncio,
      ) async {
    try {

      print('Conteúdo do corpo da requisição: ${urlResquet} : ${token}, ${idDe}, ${idPara}, ${type}, ${mensagem}, ${files}, ${idAnuncio}');

      final url = Uri.parse(urlBase + urlResquet);

      final request = http.MultipartRequest('POST', url);


      request.fields['token'] = token;
      request.fields['id_de'] = idDe.toString();
      request.fields['id_para'] = idPara.toString();
      request.fields['type'] = type.toString();
      request.fields['mensagem'] = mensagem;
      request.fields['id_anuncio'] = idAnuncio.toString();

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        request.files.add(await http.MultipartFile.fromPath('url', file.path));

      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print('Conteúdo do corpo da requisição: ${request.fields} ${request.files.first.filename}');
      print(url);
      print(responseString + " " + response.statusCode.toString());

      if (response.statusCode == 200) {
        final responseBody = json.decode(responseString);
        return responseBody;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
      throw Exception('Erro durante a requisição: $e');
    }
  }

  Future<String> sendPostRequest(String urlResquet, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse(urlBase + urlResquet),

        body: jsonEncode(body),
      );
      print(urlBase + urlResquet);
      print(response.body.toString() + " " + response.statusCode.toString());
      print(jsonEncode(body));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação POST: $e');
    }
  }

  Future<Map<String, dynamic>> getAddressFromCEP(String cep) async {
    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Falha na solicitação GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição GET: $e');
    }
  }

  Future<List<dynamic>> sendPostRequestList(String urlResquet, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse(urlBase + urlResquet),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print(urlBase + urlResquet);
      print(response.body.toString() + " " + response.statusCode.toString());
      print(body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação POST: $e');
    }
  }


  Future<String> loginRequestData(String user, String password, String token) async {
    try {
      final url = Uri.parse('$urlBase/login?user=$user&password=$password&token=$token');

      final response = await http.post(url);
      print('$urlBase/login?user=$user&password=$password&token=$token');
      print(response.body.toString() + " " + response.statusCode.toString());
      if (response.statusCode == 200) {
        return response.body.toString();
      } else if(response.statusCode == 401){
        return response.body.toString();
      }
      else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }

    } catch (e) {
      print('Erro durante a requisição: $e');
      throw Exception('Erro durante a requisição: $e');
    }
  }

  Future<dynamic> sendFileToAPI({required String token, required int userId, required File fileUrl}) async {
    try {
      final url = Uri.parse('${urlBase}usuarios/updateavatar/');

      final request = http.MultipartRequest('POST', url);
      final file = fileUrl;
      request.files.add(await http.MultipartFile.fromPath('url', file.path));
      request.fields['token'] = token;
      request.fields['id_user'] = userId.toString();



      final response = await request.send();
      final responseString = await response.stream.bytesToString();


      print('Conteúdo do corpo da requisição: ${request.fields}');
      print(url);
      print(responseString + " " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseBody = json.decode(responseString);
        return responseBody;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
      throw Exception('Erro durante a requisição: $e');
    }
  }
}
