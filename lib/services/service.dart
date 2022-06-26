import 'dart:convert';

import 'package:http/http.dart' as http;

String baseUrl = 'http://172.20.10.2:8000';

Future<Map> upload_file(String filePath) async {
  //String url = '$baseUrl/api/scantext/';
  http.MultipartRequest request = http.MultipartRequest(
    'POST',
    Uri.parse('http://172.20.10.2:8000/api/scantext/'),
  )..files.add(
      await http.MultipartFile.fromPath('image', filePath),
    );

  request.headers["CONTENT-TYPE"] = "application/json";
  http.StreamedResponse response;
  try {
    response = await request.send();
  } catch (e) {
    rethrow;
  }

  if (response.statusCode != 200) {
    throw "The response status is not 200";
  }
  String? responseValue;
  responseValue = await response.stream.bytesToString();

  Map results = jsonDecode(responseValue.toString());
  print(results);
  return results;
}

Future<Map> translateText(Map data) async {
  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse('http://172.20.10.2:8000/api/translate/'),
  )
    ..fields['text'] = data['text'].toString()
    ..fields['translate_to'] = data['translate_to'].toString();

  request.headers["CONTENT-TYPE"] = "application/json";
  http.StreamedResponse response;
  try {
    response = await request.send();
  } catch (e) {
    rethrow;
  }

  String? responseValue;

  if (response.statusCode != 200) {
    throw "Response not success";
  }
  responseValue = await response.stream.bytesToString();

  Map results = jsonDecode(responseValue.toString());
  return results;
}
