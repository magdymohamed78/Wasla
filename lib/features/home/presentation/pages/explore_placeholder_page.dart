import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';

class ExplorePlaceholderPage extends StatelessWidget {
  const ExplorePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.explorePageTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            localizations.explorePagePlaceholderMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
