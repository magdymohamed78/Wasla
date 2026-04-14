import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import '../widgets/companies_listing_view.dart';

class RecommendedCompaniesPage extends StatelessWidget {
  const RecommendedCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final getRecommendedCompaniesUseCase = context
        .read<GetRecommendedCompaniesUseCase>();

    return CompaniesListingView(
      title: localizations.homeRecommendedCompanies,
      loadPage: (pageIndex) =>
          getRecommendedCompaniesUseCase(pageIndex: pageIndex),
    );
  }
}
