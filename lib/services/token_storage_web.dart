// Web имплементација — директно користи window.localStorage
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

String? getTokenFromLocalStorage(String key) {
  return html.window.localStorage[key];
}

void setTokenInLocalStorage(String key, String value) {
  html.window.localStorage[key] = value;
}

void removeTokenFromLocalStorage(String key) {
  html.window.localStorage.remove(key);
}
