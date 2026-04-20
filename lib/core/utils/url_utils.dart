class UrlUtils {
  UrlUtils._();

  static const String _defaultApiBaseUrl = 'http://waslacrm.runasp.net/';

  static String? resolveLogoUrl(
    String? url, {
    String baseUrl = _defaultApiBaseUrl,
  }) {
    if (url == null) {
      return null;
    }

    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme && parsed.host.isNotEmpty) {
      return trimmed;
    }

    final normalizedBase = baseUrl.trim();
    if (normalizedBase.isEmpty) {
      return trimmed;
    }

    final baseUri = Uri.tryParse(normalizedBase);
    if (baseUri == null) {
      return trimmed;
    }

    return baseUri.resolve(trimmed).toString();
  }
}
