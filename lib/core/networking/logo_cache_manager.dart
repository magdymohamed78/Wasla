import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LogoCacheManager extends CacheManager {
  static const String _cacheKey = 'companyLogos';

  LogoCacheManager._()
    : super(
        Config(
          _cacheKey,
          stalePeriod: const Duration(hours: 4),
          maxNrOfCacheObjects: 200,
          fileService: HttpFileService(),
        ),
      );

  static final LogoCacheManager instance = LogoCacheManager._();

  /// Removes all cached logo files from disk AND evicts matching
  /// entries from Flutter's in-memory image cache so that stale
  /// logos are never served after a company updates its logo.
  ///
  /// Call this on app startup (before data loads) and on pull-to-refresh.
  Future<void> invalidateAll() async {
    await emptyCache();

    PaintingBinding.instance.imageCache.clear();
  }
}
