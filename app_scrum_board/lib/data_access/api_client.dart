import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

enum ApiClientType { defaultType, secure }

/// Provides a set of generic Http methods
class ApiClient {
  late final String baseUrl;
  late int _defaultTimeout;
  late HttpClient _httpClient;

  ApiClient._(ApiClientType apiClientType,
      {required this.baseUrl, int? defaultTimeout}) {
    _defaultTimeout = defaultTimeout ?? 5;
  }

  /// Get instance of ApiClient
  static Future<ApiClient> init(ApiClientType apiClientType,
      {required String baseUrl, int? defaultTimeout}) async {
    ApiClient client = ApiClient._(apiClientType,
        baseUrl: baseUrl, defaultTimeout: defaultTimeout);

    await client._initializeHttpClient(apiClientType);

    return client;
  }

  /// Building a HttpClient with either certification or without
  Future<void> _initializeHttpClient(ApiClientType apiClientType) async {
    switch (apiClientType) {
      case ApiClientType.secure:
        // p12
        var certFile = await rootBundle.load(
            "assets/flutter-test+4-client.p12"); // Get certificate p12 file
        final certBytes =
            certFile.buffer.asUint8List(); // Convert to byte array

        // var certFile = await rootBundle.load("assets/flutter-test+4.pem"); // Get certificate p12 file
        // final certBytes = certFile.buffer.asUint8List(); // Convert to byte array

        // var certFile = await rootBundle.load("assets/rootCA.pem"); // Root Test
        // final certBytes = certFile.buffer.asUint8List();

        // Pem
        var pemFile = await rootBundle.load(
            "assets/flutter-test+4-client.pem"); // Get certificate pem file
        final pemBytes = pemFile.buffer.asUint8List(); // Convert to byte array

        // Key
        var keyFile = await rootBundle.load(
            "assets/flutter-test+4-client-key.pem"); // Get certificate key pem file
        final keyBytes = keyFile.buffer.asUint8List(); // Convert to byte array

        const String password = "changeit";

        SecurityContext context = SecurityContext();

        context.setTrustedCertificatesBytes(certBytes, password: password);
        context.useCertificateChainBytes(pemBytes, password: password);
        context.usePrivateKeyBytes(keyBytes, password: password);
        _httpClient = HttpClient(context: context);
        break;
      case ApiClientType.defaultType:
        _httpClient = HttpClient();
        break;
    }
  }

  // Map<String, dynamic> _buildHeaders(Map<String, dynamic> extraHeaders) {

  // }

  // Map<String, dynamic> _mergeHeaders(Map<String, dynamic> headerMap1, Map<String, dynamic> headerMap2) {

  // }

  /// Generic GET request
  Future<HttpClientResponse> get(String endpoint,
      {int? timeout, String? token}) async {
    int requestTimeout =
        timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');

    final request = await _httpClient
        .getUrl(url)
        .timeout(Duration(seconds: requestTimeout))
      ..headers.add("Authorization", "bearer $token");

    return await request.close();
  }

  /// Generic POST request
  Future<HttpClientResponse> post(String endpoint, Map<String, dynamic> body,
      {int? timeout, String? token}) async {
    int requestTimeout =
        timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    HttpClientRequest request = await _httpClient
        .postUrl(url)
        .timeout(Duration(seconds: requestTimeout))
      ..headers.add('Content-Type', 'application/json')
      ..headers.add("Authorization", "bearer $token")
      ..add(utf8.encode(json.encode(body)));

    return await request.close();
  }

  // Generic PUT request
  Future<HttpClientResponse> put(String endpoint, Map<String, dynamic> body,
      {int? timeout, String? token}) async {
    int requestTimeout =
        timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final request =
        await _httpClient.putUrl(url).timeout(Duration(seconds: requestTimeout))
          ..headers.add('Content-Type', 'application/json')
      ..headers.add("Authorization", "bearer $token")
          ..add(utf8.encode(json.encode(body)));

    return await request.close();
  }

  /// Generic DELETE request
  Future<HttpClientResponse> delete(String endpoint,
      {int? timeout, String? token}) async {
    int requestTimeout =
        timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = await _httpClient
        .deleteUrl(url)
        .timeout(Duration(seconds: requestTimeout))
      ..headers.add("Authorization", "bearer $token");

    return await request.close();
  }
}
