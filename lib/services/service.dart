import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map> upload_file(String filePath) async {
  print("Entered upload_file");
  http.MultipartRequest request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.43.65:8000/api/scantext/'),
  )..files.add(
      await http.MultipartFile.fromPath('image', filePath),
    );

  request.headers["CONTENT-TYPE"] = "application/json";
  http.StreamedResponse response;
  try {
    print("making request");
    response = await request.send();
    print("request done");
  } catch (e) {
    print(e);
    rethrow;
  }

  String? responseValue;
  response.stream.transform(utf8.decoder).listen(
    (value) {
      print(value);
      responseValue = value;
    },
  );

  if (response.statusCode != 200) {
    throw "The response status is not 200";
  }
  Map results = jsonDecode(responseValue.toString());
  print(results);
  return results;
}

Future<Map> translateText(Map data) async {
  print("========= entered translate text");
  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse('http://192.168.43.65:8000/api/translate/'),
  )
    ..fields['text'] = data['text'].toString()
    ..fields['translate_to'] = data['translate_to'].toString();

  request.headers["CONTENT-TYPE"] = "application/json";
  http.StreamedResponse response;
  try {
    response = await request.send();
  } catch (e) {
    print(e);
    rethrow;
  }
  print("======= printing data=======");
  print(data);
  String? responseValue;

  if (response.statusCode != 200) {
    throw "Response not success";
  }
  responseValue = await response.stream.bytesToString();

  Map results = jsonDecode(responseValue.toString());
  print("results ====" + results.toString());
  return results;
}
