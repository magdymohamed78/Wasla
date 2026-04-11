import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';

class CompanyDetailsPlaceholderPage extends StatelessWidget {
  final int companyId;

  const CompanyDetailsPlaceholderPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.companyDetailsPageTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            localizations.companyDetailsPlaceholderBody(companyId.toString()),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
