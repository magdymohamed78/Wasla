import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import '../widgets/companies_listing_view.dart';

class AllCompaniesPage extends StatelessWidget {
  const AllCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final getAllCompaniesUseCase = context.read<GetAllCompaniesUseCase>();

    return CompaniesListingView(
      title: localizations.homeAllCompanies,
      loadPage: (pageIndex) => getAllCompaniesUseCase(pageIndex: pageIndex),
    );
  }
}
