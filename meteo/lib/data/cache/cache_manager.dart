import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class CacheManager {
  const CacheManager._();

  static Future<bool> setData(String key, APICacheDBModel model) async =>
      await APICacheManager().addCacheData(model);

  static Future<APICacheDBModel> getData(String key) async =>
      await APICacheManager().getCacheData(key);

  static Future<bool> delete(String key) async =>
      await APICacheManager().deleteCache(key);

  static Future<bool> containsKey(String key) async =>
      await APICacheManager().isAPICacheKeyExist(key);

  static Future<void> clearAll() async => await APICacheManager().emptyCache();
}
