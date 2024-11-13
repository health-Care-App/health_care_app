import 'package:app/google_auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app/api/utils/export.dart';
import 'package:app/api/sleep_time/post/type.dart';

//sleepTime post api呼び出し関数
Future<PostSleepTimeResponse> postSleepTime(int sleepTime) async {
  //sleepTimeの条件チェック
  if ((sleepTime < 0) || (sleepTime > 24)) {
    throw Exception(sleepTimeScaleEsception);
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
  const endPoint = "$devApiUrl$sleepTimePath";
  final url = Uri.parse(endPoint);

  //body
  final PostSleepTimeRequest request =
      PostSleepTimeRequest(sleepTime: sleepTime);
  final body = json.encode(request.toJson());

  //call api
  //成功時にjson {"message": "ok"} が返される
  http.Response response;
  try {
    response = await http.post(url, headers: headers, body: body);
  } on Exception catch (e) {
    print("$postSleepTimeException: $e");
    rethrow;
  }
  return PostSleepTimeResponse.fromJson(json.decode(response.body));
}
