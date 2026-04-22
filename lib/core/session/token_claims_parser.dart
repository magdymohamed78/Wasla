import 'dart:convert';

class TokenClaims {
  final Map<String, dynamic> raw;
  final int? customerId;
  final int? leadId;

  const TokenClaims({
    required this.raw,
    required this.customerId,
    required this.leadId,
  });

  bool get hasCustomerClaim => customerId != null;
}

class TokenClaimsParser {
  static const List<String> _customerClaimAliases = <String>[
    'customerId',
    'customer_id',
    'CustomerId',
  ];

  static const List<String> _leadClaimAliases = <String>[
    'leadId',
    'lead_id',
    'LeadId',
  ];

  const TokenClaimsParser();

  TokenClaims? parse(String? token) {
    if (token == null || token.trim().isEmpty) {
      return null;
    }

    final parts = token.split('.');
    if (parts.length < 2) {
      return null;
    }

    try {
      final payloadBytes = base64Url.decode(base64Url.normalize(parts[1]));
      final payloadText = utf8.decode(payloadBytes);
      final payloadJson = json.decode(payloadText);
      if (payloadJson is! Map<String, dynamic>) {
        return null;
      }

      return TokenClaims(
        raw: payloadJson,
        customerId: _extractPositiveInt(
          payloadJson,
          aliases: _customerClaimAliases,
          suffix: 'customerid',
        ),
        leadId: _extractPositiveInt(
          payloadJson,
          aliases: _leadClaimAliases,
          suffix: 'leadid',
        ),
      );
    } catch (_) {
      return null;
    }
  }

  int? _extractPositiveInt(
    Map<String, dynamic> claims, {
    required List<String> aliases,
    required String suffix,
  }) {
    for (final alias in aliases) {
      if (claims.containsKey(alias)) {
        final value = _toPositiveInt(claims[alias]);
        if (value != null) {
          return value;
        }
      }
    }

    final target = suffix.toLowerCase();
    for (final entry in claims.entries) {
      final key = entry.key.toLowerCase();
      if (key == target ||
          key.endsWith('/$target') ||
          key.endsWith(':$target') ||
          key.endsWith('_$target')) {
        final value = _toPositiveInt(entry.value);
        if (value != null) {
          return value;
        }
      }
    }

    return null;
  }

  int? _toPositiveInt(dynamic value) {
    final parsed = _toInt(value);
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    if (value is List && value.isNotEmpty) {
      return _toInt(value.first);
    }

    return null;
  }
}
