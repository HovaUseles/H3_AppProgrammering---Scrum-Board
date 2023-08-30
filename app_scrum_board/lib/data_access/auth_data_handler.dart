import 'dart:convert';

import 'package:localstore/localstore.dart';

import 'api_client.dart';

class AuthDataHandler {
  final _apiClient =
      ApiClient(ApiClientType.secure, baseUrl: "https://10.0.2.2:5002/api");

  final db = Localstore.instance;

  /// Request API for a new access token and saves it locally
  Future<String> _requestAccessToken(String username, String password) async {
    Map<String, Object> mapBody = {"username": username, "password": password};
    var response = await _apiClient.post("Authentication/Login", mapBody);
    String responseBody = await response.transform(utf8.decoder).join();
    String token = jsonDecode(responseBody)["token"];

    await _saveTokenToLocal(token); // Save locally
    return token;
  }

  /// Removes old Access Token and saves new locally
  Future<void> _saveTokenToLocal(String token) async {
    await db.collection("access_token").delete(); // Remove old token
    Map<String, dynamic> tokenMap = {"token": token};
    db.collection("access_token").doc().set(tokenMap);
  }

  /// Try get Access Token from local storage
  Future<String?> _getTokenFromLocal() async {
    var tokens = await db.collection("access_token").get();
    if (tokens == null) {
      return null;
    }
    Map<String, dynamic> localMap = tokens.entries.first.value;
    return localMap["token"];
  }

  /// Get Access Token to be used for other calls
  Future<String> getAccessToken() async {
    try {
      String? localToken = await _getTokenFromLocal();
      if (localToken != null) {
        var response = await _apiClient.get("Authentication/ValidateAccessToken"); // Validate if local token is active
        // If local token is valid return it
        if (response.statusCode == 200) {
          return localToken;
        }
      }
      return await _requestAccessToken("FlutterTester", "FlutterTest");
    } 
    catch (ex) {
      rethrow;
    }
  }
}
