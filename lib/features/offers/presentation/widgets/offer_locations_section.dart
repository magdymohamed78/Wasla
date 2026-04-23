import 'package:flutter/material.dart';

import '../../domain/entities/offer_location.dart';
import 'offer_location_card.dart';

class OfferLocationsSection extends StatelessWidget {
  final List<OfferLocation> locations;

  const OfferLocationsSection({super.key, required this.locations});

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return const SizedBox.shrink();

    // Sort so Origin comes first, then Destination, then others by index.
    final sorted = List<OfferLocation>.from(locations)
      ..sort((a, b) {
        final aType = a.locationType?.toLowerCase();
        final bType = b.locationType?.toLowerCase();
        if (aType == 'origin' && bType != 'origin') return -1;
        if (bType == 'origin' && aType != 'origin') return 1;
        if (aType == 'destination' && bType != 'destination') return 1;
        if (bType == 'destination' && aType != 'destination') return -1;
        return a.addressIndex.compareTo(b.addressIndex);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (var i = 0; i < sorted.length; i++)
          OfferLocationCard(
            location: sorted[i],
            isFirst: i == 0,
            isLast: i == sorted.length - 1,
            isConnected: sorted.length > 1,
          ),
      ],
    );
  }
}
