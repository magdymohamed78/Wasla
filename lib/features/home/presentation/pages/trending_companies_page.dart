import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import '../widgets/companies_listing_view.dart';

class TrendingCompaniesPage extends StatelessWidget {
  const TrendingCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final getTrendingCompaniesUseCase = context
        .read<GetTrendingCompaniesUseCase>();

    return CompaniesListingView(
      title: localizations.homeTrendingCompanies,
      showTrendIndicator: true,
      loadPage: (pageIndex) =>
          getTrendingCompaniesUseCase(pageIndex: pageIndex),
    );
  }
}
