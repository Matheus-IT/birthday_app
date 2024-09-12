import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _httpClient =
    IOClient(HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true);

class MyAuthenticatedHttpClient {
  static Future<http.Response> get(Uri url) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await _httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  static Future<http.Response> put(Uri url, Map payload) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await _httpClient.put(
      url,
      body: jsonEncode(payload),
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  static Future<http.Response> post(Uri url, Map payload) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await _httpClient.post(
      url,
      body: jsonEncode(payload),
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  static Future<http.Response> delete(Uri url) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await _httpClient.delete(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}

class MyHttpClient {
  static Future<http.Response> post(Uri url, Map body) async {
    final response = await _httpClient.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    return response;
  }
}
