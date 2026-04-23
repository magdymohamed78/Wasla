import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum OfferFilter {
  all,
  pending,
  accepted,
  rejected,
  expired;

  String toQueryValue() {
    switch (this) {
      case OfferFilter.all:
        return '';
      case OfferFilter.pending:
        return 'Pending';
      case OfferFilter.accepted:
        return 'Accepted';
      case OfferFilter.rejected:
        return 'Rejected';
      case OfferFilter.expired:
        return 'Expired';
    }
  }

  static OfferFilter fromQueryValue(String? value) {
    if (value == null || value.trim().isEmpty) return OfferFilter.all;
    final normalized = value.trim().toLowerCase();

    if (normalized == 'sent') {
      return OfferFilter.pending;
    }
    if (normalized == 'declined') {
      return OfferFilter.rejected;
    }

    return OfferFilter.values.firstWhere(
      (filter) =>
          filter != OfferFilter.all && filter.name.toLowerCase() == normalized,
      orElse: () => OfferFilter.all,
    );
  }

  static Color resolveColor(OfferFilter filter) {
    switch (filter) {
      case OfferFilter.all:
        return AppColors.brandRed;
      case OfferFilter.pending:
        return AppColors.statusPending;
      case OfferFilter.accepted:
        return AppColors.statusAccepted;
      case OfferFilter.rejected:
        return AppColors.statusDeclined;
      case OfferFilter.expired:
        return AppColors.statusExpired;
    }
  }
}
