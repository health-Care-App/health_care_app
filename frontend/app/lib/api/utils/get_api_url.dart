import 'package:app/api/utils/export.dart';
import 'package:flutter/foundation.dart';

//開発環境によってサーバーのエンドポイントを変える
String getRootApiUrl() {
  if (kDebugMode) {
    return devApiUrl;
  } else {
    return prodApiUrl;
  }
}
