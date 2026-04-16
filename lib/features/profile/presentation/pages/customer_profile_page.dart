import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/customer_profile_cubit.dart';
import '../widgets/connected_company_card.dart';
import '../widgets/profile_components.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerProfileCubit>(
      create: (context) => CustomerProfileCubit(
        getCustomerProfileUseCase: context.read<GetCustomerProfileUseCase>(),
      )..load(),
      child: const _CustomerProfileView(),
    );
  }
}

class _CustomerProfileView extends StatelessWidget {
  const _CustomerProfileView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading ||
                state.status == LoadStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == LoadStatus.error || state.profile == null) {
              return _RetryState(
                message: localizations.networkErrorServer,
                onRetry: context.read<CustomerProfileCubit>().load,
              );
            }

            final profile = state.profile!;
            final companies = profile.connectedCompanies;
            final visibleCompanies = companies.take(4).toList(growable: false);

            return RefreshIndicator(
              onRefresh: context.read<CustomerProfileCubit>().load,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                children: [
                  ProfileAvatarHeader(
                    firstName: profile.firstName ?? '',
                    lastName: profile.lastName ?? '',
                    roleLabel: localizations.profileRoleCustomer,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  ProfileSectionCard(
                    title: localizations.profilePersonalDetailsTitle,
                    sectionIcon: Icons.person_outline,
                    trailing: EditProfileButton(
                      label: localizations.profileEditPageTitle,
                      onPressed: () async {
                        final updated = await context.push<bool>(
                          AppRouter.customerProfileEdit,
                        );

                        if (updated == true && context.mounted) {
                          context.read<CustomerProfileCubit>().load();
                        }
                      },
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
                          value: _valueOrDash(profile.email),
                        ),
                        const Divider(color: AppColors.divider),
                        ProfileInfoRow(
                          icon: Icons.phone_outlined,
                          label: localizations.profilePhoneLabel,
                          value: _valueOrDash(profile.phoneNumber),
                        ),
                        const Divider(color: AppColors.divider),
                        ProfileInfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: localizations.profileMemberSince,
                          value: _formatDate(context, profile.createdAt),
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
                          value: _valueOrDash(profile.address),
                        ),
                        const Divider(color: AppColors.divider),
                        ProfileInfoRow(
                          icon: Icons.map_outlined,
                          label: localizations.profileCityZipLabel,
                          value: _combineCityZip(profile.city, profile.zipCode),
                        ),
                        const Divider(color: AppColors.divider),
                        ProfileInfoRow(
                          icon: Icons.public_outlined,
                          label: localizations.profileCountryLabel,
                          value: _valueOrDash(profile.country),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  ProfileSectionCard(
                    title: localizations.profileConnectedCompaniesTitle,
                    sectionIcon: Icons.business_outlined,
                    trailing: companies.length > 4
                        ? TextButton(
                            onPressed: () {
                              context.push(
                                AppRouter.customerConnectedCompanies,
                                extra: companies,
                              );
                            },
                            child: Text(
                              localizations.homeViewAll,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.brandRed,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : null,
                    child: companies.isEmpty
                        ? ProfileEmptyState(
                            title: localizations
                                .profileConnectedCompaniesEmptyTitle,
                            message: localizations
                                .profileConnectedCompaniesEmptyMessage,
                          )
                        : Column(
                            children: visibleCompanies
                                .map(
                                  (company) =>
                                      ConnectedCompanyCard(company: company),
                                )
                                .toList(growable: false),
                          ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _valueOrDash(String? value) {
    final normalized = (value ?? '').trim();
    return normalized.isEmpty ? '-' : normalized;
  }

  String _combineCityZip(String? city, String? zipCode) {
    final cityValue = (city ?? '').trim();
    final zipValue = (zipCode ?? '').trim();

    if (cityValue.isEmpty && zipValue.isEmpty) {
      return '-';
    }

    if (cityValue.isNotEmpty && zipValue.isNotEmpty) {
      return '$cityValue, $zipValue';
    }

    return cityValue.isNotEmpty ? cityValue : zipValue;
  }

  String _formatDate(BuildContext context, DateTime? value) {
    if (value == null) {
      return '-';
    }

    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(value.toLocal());
  }
}

class _RetryState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _RetryState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
