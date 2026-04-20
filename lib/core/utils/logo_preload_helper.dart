import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../networking/logo_cache_manager.dart';
import 'url_utils.dart';

Future<void> precacheCompanyLogos(
  BuildContext context,
  List<String?> logoUrls, {
  int maxCount = 10,
}) async {
  final urls = logoUrls
      .map(UrlUtils.resolveLogoUrl)
      .whereType<String>()
      .where((url) => url.trim().isNotEmpty)
      .take(maxCount)
      .toList(growable: false);

  for (final url in urls) {
    try {
      await precacheImage(
        CachedNetworkImageProvider(url, cacheManager: LogoCacheManager.instance),
        context,
      );
    } catch (_) {
      // Ignore preload failures and let widget fallbacks handle rendering.
    }
  }
}
