import 'package:app/google_auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app/api/utils/export.dart';
import 'package:app/api/health/post/type.dart';

//health post api呼び出し関数
Future<PostHealthResponse> postHealth(int health) async {
  //healthの条件チェック
  if ((health < 1) || (health > 10)) {
    throw Exception(healthScaleException);
  }

  //idtoken取得してheaderにidToken追加
  String idToken;
  try {
    idToken = await Authentication.getIdToken();
  } on Exception catch (e) {
    print("$idTokenException: $e");
    rethrow;
  }
  headers["Authorization"] = "Bearer $idToken";

  //url
  const endPoint = "$prodApiUrl$healthPath";
  final url = Uri.parse(endPoint);

  //body
  final PostHealthRequest request = PostHealthRequest(health: health);
  final body = json.encode(request.toJson());

  //call api
  //成功時にjson {"message": "ok"} が返される
  http.Response response;
  try {
    response = await http.post(url, headers: headers, body: body);
  } on Exception catch (e) {
    print("$postHealthException: $e");
    rethrow;
  }
  return PostHealthResponse.fromJson(json.decode(response.body));
}
