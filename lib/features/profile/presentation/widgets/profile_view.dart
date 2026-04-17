import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/customer_portal_content.dart';
import '../helpers/profile_helpers.dart';
import '../widgets/connected_company_card.dart';
import '../widgets/profile_components.dart';

class ProfileViewData {
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;
  final DateTime? createdAt;
  final List<ConnectedCompany> connectedCompanies;

  const ProfileViewData({
    this.firstName = '',
    this.lastName = '',
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
    this.createdAt,
    this.connectedCompanies = const <ConnectedCompany>[],
  });
}

class ProfileView extends StatelessWidget {
  final String roleLabel;
  final VoidCallback onEdit;
  final ProfileViewData profile;

  const ProfileView({
    super.key,
    required this.roleLabel,
    required this.onEdit,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final companies = profile.connectedCompanies;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        ProfileAvatarHeader(
          firstName: profile.firstName,
          lastName: profile.lastName,
          roleLabel: roleLabel,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        ProfileSectionCard(
          title: localizations.profilePersonalDetailsTitle,
          sectionIcon: Icons.person_outline,
          trailing: EditProfileButton(
            label: localizations.profileEditPageTitle,
            onPressed: onEdit,
          ),
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.person_outline,
                label: localizations.profileFullNameLabel,
                value: buildFullName(
                  firstName: profile.firstName,
                  lastName: profile.lastName,
                ),
              ),
              const Divider(color: AppColors.divider),
              ProfileInfoRow(
                icon: Icons.email_outlined,
                label: localizations.profileEmailLabel,
                value: valueOrDash(profile.email),
              ),
              const Divider(color: AppColors.divider),
              ProfileInfoRow(
                icon: Icons.phone_outlined,
                label: localizations.profilePhoneLabel,
                value: valueOrDash(profile.phoneNumber),
              ),
              const Divider(color: AppColors.divider),
              ProfileInfoRow(
                icon: Icons.calendar_today_outlined,
                label: localizations.profileMemberSince,
                value: formatDate(context, profile.createdAt),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        ProfileSectionCard(
          title: localizations.profileAddressInformationTitle,
          sectionIcon: Icons.location_on_outlined,
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.location_on_outlined,
                label: localizations.profileStreetAddress,
                value: valueOrDash(profile.address),
              ),
              const Divider(color: AppColors.divider),
              ProfileInfoRow(
                icon: Icons.map_outlined,
                label: localizations.profileCityZipLabel,
                value: combineCityZip(profile.city, profile.zipCode),
              ),
              const Divider(color: AppColors.divider),
              ProfileInfoRow(
                icon: Icons.public_outlined,
                label: localizations.profileCountryLabel,
                value: valueOrDash(profile.country),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        ProfileSectionCard(
          title: localizations.profileConnectedCompaniesTitle,
          sectionIcon: Icons.business_outlined,
          child: companies.isEmpty
              ? ProfileEmptyState(
                  title: localizations.profileConnectedCompaniesEmptyTitle,
                  message: localizations.profileConnectedCompaniesEmptyMessage,
                )
              : _ConnectedCompaniesList(companies: companies),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}

class _ConnectedCompaniesList extends StatefulWidget {
  final List<ConnectedCompany> companies;

  const _ConnectedCompaniesList({required this.companies});

  @override
  State<_ConnectedCompaniesList> createState() =>
      _ConnectedCompaniesListState();
}

class _ConnectedCompaniesListState extends State<_ConnectedCompaniesList> {
  static const int _initialCount = 2;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final visible = _expanded
        ? widget.companies
        : widget.companies.take(_initialCount).toList();
    final remaining = widget.companies.length - visible.length;

    return Column(
      children: [
        for (final company in visible)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: ConnectedCompanyCard(company: company),
          ),
        if (remaining > 0)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
            child: Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _expanded = true),
                icon: const Icon(
                  Icons.expand_more_rounded,
                  size: 20,
                  color: AppColors.brandRed,
                ),
                label: Text(
                  localizations.profileCompanyLoadMore(remaining),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.brandRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
