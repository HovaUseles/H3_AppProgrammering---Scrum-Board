import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

enum ApiClientType { defaultType, secure }

/// Provides a set of generic Http methods
class ApiClient {
  final String baseUrl;
  late int _defaultTimeout;
  late HttpClient _httpClient;

  ApiClient(ApiClientType apiClientType, {required this.baseUrl, int? defaultTimeout}) {
    _defaultTimeout = defaultTimeout ?? 5;
    _initializeClient(apiClientType);
  }

  void _initializeClient(ApiClientType apiClientType) async {
    switch(apiClientType) {
      case ApiClientType.secure:
      var certFile = await rootBundle.load("assets/flutter-test+5.p12"); // Get certificate p12 file
      final certBytes = certFile.buffer.asUint8List(); // Convert to byte array
      SecurityContext context = SecurityContext();
      context.setTrustedCertificatesBytes(certBytes, password: "MyPassword"); // Set certificate
      _httpClient = HttpClient(context: context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // For debug
        break;
      case ApiClientType.defaultType:
        _httpClient = HttpClient();
        break;
    }
  }

  /// Generic GET request
  Future<HttpClientResponse> get(String endpoint, {int? timeout, Map<String, String>? headers}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    
    final request = await _httpClient.getUrl(url)
      .timeout(Duration(seconds: requestTimeout));

    if(headers != null) {
      for (var header in headers.entries) {
        request.headers.add(header.key, header.value);
      }
    } 

    return await request.close();
  }

  /// Generic POST request
  Future<HttpClientResponse> post(String endpoint, Map<String, dynamic> body, {int? timeout, Map<String, String>? headers}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = await _httpClient.postUrl(url)
      .timeout(Duration(seconds: requestTimeout))
      ..headers.add('Content-Type', 'application/json')
      ..add(utf8.encode(json.encode(body)));

    if(headers != null) {
      for (var header in headers.entries) {
        request.headers.add(header.key, header.value);
      }
    }

    return await request.close();
  }

  // Generic PUT request
  Future<HttpClientResponse> put(String endpoint, Map<String, dynamic> body, {int? timeout, Map<String, String>? headers}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = await _httpClient.putUrl(url)
      .timeout(Duration(seconds: requestTimeout))
      ..headers.add('Content-Type', 'application/json')
      ..add(utf8.encode(json.encode(body)));
      
    if(headers != null) {
      for (var header in headers.entries) {
        request.headers.add(header.key, header.value);
      }
    }

    return await request.close();
  }

  /// Generic DELETE request
  Future<HttpClientResponse> delete(String endpoint, {int? timeout, Map<String, String>? headers}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = await _httpClient.deleteUrl(url)
      .timeout(Duration(seconds: requestTimeout));

    if(headers != null) {
      for (var header in headers.entries) {
        request.headers.add(header.key, header.value);
      }
    }

    return await request.close();
  }
}