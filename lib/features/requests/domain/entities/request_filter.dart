import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum RequestFilter {
  all,
  pending,
  offerSent,
  declined,
  expired;

  String toQueryValue() {
    switch (this) {
      case RequestFilter.all:
        return '';
      case RequestFilter.pending:
        return 'Pending';
      case RequestFilter.offerSent:
        return 'OfferSent';
      case RequestFilter.declined:
        return 'Declined';
      case RequestFilter.expired:
        return 'Expired';
    }
  }

  static RequestFilter fromQueryValue(String? value) {
    if (value == null || value.trim().isEmpty) return RequestFilter.all;
    final normalized = value.trim().toLowerCase();
    return RequestFilter.values.firstWhere(
      (filter) =>
          filter != RequestFilter.all &&
          filter.name.toLowerCase() == normalized,
      orElse: () => RequestFilter.all,
    );
  }

  static Color resolveColor(RequestFilter filter) {
    switch (filter) {
      case RequestFilter.all:
        return AppColors.brandRed;
      case RequestFilter.pending:
        return AppColors.statusPending;
      case RequestFilter.offerSent:
        return AppColors.statusOfferSent;
      case RequestFilter.declined:
        return AppColors.statusDeclined;
      case RequestFilter.expired:
        return AppColors.statusExpired;
    }
  }
}
