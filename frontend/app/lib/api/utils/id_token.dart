import 'package:http/http.dart' as http;
import 'dart:convert';
import 'export.dart';

//google sign in パッケージいずれ使うのでコメントアウト
//import 'package:google_sign_in/google_sign_in.dart';

// 仮idtoken取得関数
// google認証が有効になったらそれを使ったidtoken取得処理を追加してこれを消す予定
Future<String> getIdToken() async {
  const endPoint =
      "http://127.0.0.1:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCnrLRKRBpCDIi4-yhC8QebKVvyPmtvXMk";
  final url = Uri.parse(endPoint);
  final body = json.encode({
    "email": "user1@sample.com",
    "password": "user1_password",
    "returnSecureToken": true
  });
  http.Response response = await http.post(url, headers: headers, body: body);
  final parsedJson = json.decode(response.body);
  return parsedJson['idToken'];
}
