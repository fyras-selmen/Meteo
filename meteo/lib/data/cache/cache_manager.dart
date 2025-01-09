import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class CacheManager {
  // Constructeur privé pour empêcher l'instanciation de cette classe
  const CacheManager._();

  // Méthode statique pour ajouter des données au cache
  static Future<bool> setData(String key, APICacheDBModel model) async =>
      await APICacheManager().addCacheData(model);

  // Méthode statique pour récupérer des données du cache
  static Future<APICacheDBModel> getData(String key) async =>
      await APICacheManager().getCacheData(key);

  // Méthode statique pour supprimer des données du cache
  static Future<bool> delete(String key) async =>
      await APICacheManager().deleteCache(key);

  // Méthode statique pour vérifier si une clé existe dans le cache
  static Future<bool> containsKey(String key) async =>
      await APICacheManager().isAPICacheKeyExist(key);

  static Future<void> clearAll() async => await APICacheManager().emptyCache();
}
