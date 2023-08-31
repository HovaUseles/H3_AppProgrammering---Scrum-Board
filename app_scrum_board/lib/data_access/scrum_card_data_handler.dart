import 'dart:async';
import 'dart:convert';

import 'package:app_scrum_board/data_access/auth_data_handler.dart';
import 'package:app_scrum_board/data_access/cache_service.dart';
import 'package:app_scrum_board/services/locators.dart';

import '../exceptions/_exceptions.dart';
import '../models/_models.dart';
import 'api_client.dart';

class ScrumCardDataHandler {
  late final ApiClient _apiClient;
  bool _isApiClientInitialized = false;

  final String _entityContext = "ScrumCard";
  final AuthDataHandler _authHandler =
      locator<AuthDataHandler>(); // Inject handler
  final CacheService _cacheService = CacheService(entityContext: "ScrumCard");

  /// Ensures that the ApiClient has been async initialized
  Future<void> _initApiClient() async {
    if (_isApiClientInitialized) return;

    _apiClient = await ApiClient.init(ApiClientType.secure,
        baseUrl: "https://10.0.2.2:5002/api");
    _isApiClientInitialized = true;
  }

  /// Gets all the items from external API
  Future<List<ScrumCard>> getAll() async {
    await _initApiClient();
    String token = await _authHandler.getAccessToken(); // Get Access token
    try {
      var response = await _apiClient.get(_entityContext, token: token);

      String responseBody = await response.transform(utf8.decoder).join();
      if (responseBody.isEmpty) {
        return [];
      }
      Iterable jsonArray = json.decode(responseBody);
      List<ScrumCard> scrumCards = List<ScrumCard>.from(jsonArray.map(
              (jsonObject) => ScrumCard.fromMap(
                  jsonObject)) // Turn json array into Gallery Item objects
          );

      await _cacheService.setCache(responseBody); // Set Cache

      return scrumCards;
    } on (TimeoutException timeoutEx,) {
      String? localCache = await _cacheService.get();
      if (localCache != null) {
        Iterable jsonArray = json.decode(localCache);
        List<ScrumCard> scrumCardsCache = List<ScrumCard>.from(jsonArray.map(
                (jsonObject) => ScrumCard.fromMap(
                    jsonObject)) // Turn json array into Gallery Item objects
            );
        return scrumCardsCache;
      }
      return []; // If no cached data, return empty lists
    } catch (ex) {
      rethrow;
    }
  }

  /// Gets an item from external API
  Future<ScrumCard> get(String id) async {
    await _initApiClient();
    String token = await _authHandler.getAccessToken(); // Get Access token
    var response = await _apiClient.get("$_entityContext/$id", token: token);
    String responseBody = await response.transform(utf8.decoder).join();
    ScrumCard scrumCard = ScrumCard.fromJson(responseBody);
    return scrumCard;
  }

  /// Saves an item on external API
  Future<ScrumCard> create(ScrumCard scrumCard) async {
    await _initApiClient();
    String token = await _authHandler.getAccessToken(); // Get Access token
      Map<String, dynamic> jsonBody = scrumCard.toMap();
    var response =
        await _apiClient.post(_entityContext, jsonBody, token: token);
    if( response.statusCode == 400) {
      throw BadRequestException("The server did not accept the content");
    }

    String responseBody = await response.transform(utf8.decoder).join();
    if (responseBody.isNotEmpty) {
      ScrumCard createdScrumCard =
          ScrumCard.fromJson(responseBody); // Should return the created model
      return createdScrumCard;
    }

    // Check for Uri header
    String? uri = response.headers.value("location");
    if (uri == null) {
      throw MissingUriException(
          message: "Missing URI for created ${(ScrumCard).toString()}");
    }
    // Get created item from the location if not null.
    return await get(uri);
  }

  /// Updates an items on external API
  Future<bool> edit(ScrumCard scrumCardChanges) async {
    await _initApiClient();
    String token = await _authHandler.getAccessToken(); // Get Access token
    Map<String, dynamic> jsonBody = scrumCardChanges.toMap();
    await _apiClient.put("$_entityContext/${scrumCardChanges.id}", jsonBody,
        token:
            token); // Saving response for easy extension refactor of the method
    return true;
  }

  /// Deletes an items on external API
  Future<bool> delete(String id) async {
    await _initApiClient();
    String token = await _authHandler.getAccessToken(); // Get Access token
    await _apiClient.delete("$_entityContext/$id",
        token:
            token); // Saving response for easy extension refactor of the method
    return true;
  }
}
