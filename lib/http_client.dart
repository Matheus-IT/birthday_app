import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticatedHttpClient {
  static Future<http.Response> get(Uri url) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    return response;
  }

  static Future<http.Response> put(Uri url, Map payload) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await http.put(
      url,
      body: jsonEncode(payload),
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    return response;
  }

  static Future<http.Response> post(Uri url, Map payload) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
      url,
      body: jsonEncode(payload),
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    return response;
  }

  static Future<http.Response> delete(Uri url) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final response = await http.delete(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    return response;
  }
}

class HttpClient {
  static Future<http.Response> post(Uri url, Map body) async {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    return response;
  }
}
