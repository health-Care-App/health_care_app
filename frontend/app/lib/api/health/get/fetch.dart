import 'package:app/google_auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:app/api/health/get/type.dart';
import 'package:app/api/utils/export.dart';

//health get api呼び出し関数
Future<GetHealthResponse> getHealth({DateTime? oldDateTime}) async {
  //日付時間処理
  oldDateTime = oldDateTime ?? getDefaultOldTime();
  // UTC timezone
  String utcDateTime =
      "${DateFormat(dateTimePattern).format(oldDateTime.toUtc())}Z";

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
  final rootApiUrl = getRootApiUrl();
  final endPoint = "$rootApiUrl$healthPath?oldDateAt=$utcDateTime";
  final url = Uri.parse(endPoint);

  //call api
  http.Response response;
  try {
    response = await http.get(url, headers: headers);
  } on Exception catch (e) {
    print("$getHealthException: $e");
    rethrow;
  }
  return GetHealthResponse.fromJson(json.decode(response.body));
}
