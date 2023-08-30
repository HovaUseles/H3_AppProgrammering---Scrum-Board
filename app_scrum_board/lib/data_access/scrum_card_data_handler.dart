import 'dart:async';
import 'dart:convert';

import 'package:app_scrum_board/data_access/cache_service.dart';

import '../exceptions/_exceptions.dart';
import '../models/_models.dart';
import 'api_client.dart';

class ScrumCardDataHandler {
  final _apiClient =
      ApiClient(ApiClientType.secure, baseUrl: "https://10.0.2.2:5002/api");
  final String _entityContext = "ScrumCard";
  final CacheService _cacheService = CacheService(entityContext: "ScrumCard");

  /// Gets all the items from external API
  Future<List<ScrumCard>> getAll() async {
    try {
      var response = await _apiClient.get(_entityContext);

      String responseBody = await response.transform(utf8.decoder).join();
      Iterable jsonArray = json.decode(responseBody);
      List<ScrumCard> scrumCards = List<ScrumCard>.from(jsonArray.map(
              (jsonObject) => ScrumCard.fromMap(
                  jsonObject)) // Turn json array into Gallery Item objects
          );

      await _cacheService.setCache(responseBody); // Set Cache

      /*
      // Caching items to local db, to enable offline use
      await db.collection(_entityContext).delete(); // Empty existing cache
      for (int i = 0; i < scrumCards.length; i++) {
        var scrumCard = scrumCards[i];
        final id = db.collection(_entityContext).doc().id; // Returns a new Id
        var map = scrumCard.toMap(); // Get item map
        // Save to local storage
        await db.collection(_entityContext).doc(id).set(map);
      }
      */
      return scrumCards;
    }
    on(TimeoutException, ) {
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
    }
    catch (ex) {
      rethrow;
      /*
      // Get data from local storage
      var localItems = await db.collection(_entityContext).get();
      if (localItems == null) {
        return [];
      }
      List<ScrumCard> scrumCards = [];
      // map localstorage items to ScrumCards
      for (int i = 0; i < localItems.entries.length; i++) {
        var map = localItems[localItems.entries.elementAt(i).key];
        scrumCards.add(ScrumCard.fromMap(map));
      }
      return scrumCards; // Return cached data
      */
    }
  }

  /// Gets an item from external API
  Future<ScrumCard> get(String id) async {
    var response = await _apiClient.get("$_entityContext/$id");
    String responseBody = await response.transform(utf8.decoder).join();
    ScrumCard scrumCard = ScrumCard.fromJson(responseBody);
    return scrumCard;
  }

  /// Saves an item on external API
  Future<ScrumCard> create(ScrumCard scrumCard) async {
    Map<String, dynamic> jsonBody = scrumCard.toMap();
    var response = await _apiClient.post(_entityContext, jsonBody);
    String responseBody = await response.transform(utf8.decoder).join();
    if (responseBody.isNotEmpty) {
      try {
        ScrumCard createdScrumCard =
            ScrumCard.fromJson(responseBody); // Should return the created model
        return createdScrumCard;
      } catch (ex) {
        rethrow;
      }
    }

    // Check for Uri header
    String? uri = response.headers.value("location");
    if (uri == null) {
      throw MissingUriException(
          message: "Missing URI for created ${(ScrumCard).toString()}");
    }
    // Get created item from the location if not null.
    return await get(uri);
    /*
    var getResponse = await _apiClient.get(uri);
    String uriResponseBody = await getResponse.transform(utf8.decoder).join();
    ScrumCard createdScrumCard = ScrumCard.fromJson(uriResponseBody);
    return createdScrumCard;
    */
  }

  /// Updates an items on external API
  Future<bool> edit(ScrumCard scrumCardChanges) async {
    Map<String, dynamic> jsonBody = scrumCardChanges.toMap();
    await _apiClient.put("$_entityContext/${scrumCardChanges.id}",
        jsonBody); // Saving response for easy extension refactor of the method
    return true;
  }

  /// Deletes an items on external API
  Future<bool> delete(String id) async {
    await _apiClient.delete(
        "$_entityContext/$id"); // Saving response for easy extension refactor of the method
    return true;
  }
}
