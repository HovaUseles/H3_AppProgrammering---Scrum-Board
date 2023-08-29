import 'dart:convert';

import 'package:api_cert_test/data_access/api_client.dart';
import 'package:localstore/localstore.dart';

class DataHandler {
  final _apiClient =
      ApiClient(ApiClientType.secure, baseUrl: "https://10.0.2.2:5002/api");
      
  final db = Localstore.instance;

  Future<String> _requestAccessToken(String username, String password) async {
    Map<String, Object> mapBody = {"username": username, "password": password};
    var response = await _apiClient.post("Authentication/Login", mapBody);
    String responseBody = await response.transform(utf8.decoder).join();
    String token = jsonDecode(responseBody)["token"];

    await _saveTokenToLocal(token); // Save locally
    return token;
  }

  Future<void> _saveTokenToLocal(String token) async {
    await db.collection("access_token").delete(); // Remove old token
    Map<String, dynamic> tokenMap = {
      "token": token
    };
    db.collection("access_token").doc().set(tokenMap);
  }

  Future<String?> _getTokenFromLocal() async {
      var tokens = await db.collection("access_token").get();
      if(tokens == null) {
        return null;
      }
      Map<String, dynamic> localMap = tokens.entries.first.value;
      return localMap["token"];
  }

  Future<String> getHelloWorld() async {
    try {
      String token = await _getTokenFromLocal() 
        ?? await _requestAccessToken("FlutterTester", "FlutterTest");
      var response = await _apiClient.get("home", headers: {
        "Authorization": "Bearer $token"
      });
      if(response.statusCode == 200) {
        return await response.transform(utf8.decoder).join();
      }
      else if (response.statusCode == 401) {
        token = await _requestAccessToken("FlutterTester", "FlutterTest");
        var response = await _apiClient.get("home", headers: {
          "Authorization": "Bearer $token"
        });
        return await response.transform(utf8.decoder).join();
      }
      throw Exception("Could not get data");
    }
    catch (ex) {
      rethrow;
    }
  }
}
