import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/customer_portal_content.dart';
import '../widgets/connected_company_card.dart';
import '../widgets/profile_components.dart';

class CustomerConnectedCompaniesPage extends StatelessWidget {
  final List<ConnectedCompany> companies;

  const CustomerConnectedCompaniesPage({super.key, required this.companies});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(localizations.profileConnectedCompaniesTitle),
      ),
      body: SafeArea(
        child: companies.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: ProfileEmptyState(
                  title: localizations.profileConnectedCompaniesEmptyTitle,
                  message: localizations.profileConnectedCompaniesEmptyMessage,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return ConnectedCompanyCard(company: companies[index]);
                },
              ),
      ),
    );
  }
}
