import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final String entityContext;
  final Duration defaultExpiryTime;

  CacheService({required this.entityContext, Duration? defaultExpiryTime})
      : defaultExpiryTime = defaultExpiryTime ??
            const Duration(minutes: 30); // Setting default cache expiry time

  /// Stores data locally with a expiry time
  Future<void> setCache(String cacheData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store expiry time in cache
    DateTime now = DateTime.now();
    await prefs.setInt(
        '${entityContext}_expiry_time',
        now
            .add(defaultExpiryTime)
            .millisecondsSinceEpoch); // Save expiry time in milliseconds

    await prefs.setString(entityContext, cacheData);
  }

  /// Get cached data if it has not passed the expiry time
  Future<String?> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedResponse = prefs.getString(entityContext);
    int? expiryTimeInMilliseconds = prefs.getInt('${entityContext}_expiry_time');
    if(expiryTimeInMilliseconds == null) {
      return null; // return if no expiry time, since no way to verify age of the cache
    }
    // Check if cached data has expired
    DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimeInMilliseconds);
    DateTime now = DateTime.now();
    if(now.isAfter(expiryTime)) {
      return null;
    }
    return cachedResponse;
  }
}
