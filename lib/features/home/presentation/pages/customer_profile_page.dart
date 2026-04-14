import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/customer_profile_cubit.dart';

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

            return RefreshIndicator(
              onRefresh: context.read<CustomerProfileCubit>().load,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                children: [
                  _ProfileCard(
                    title: profile.fullName.isEmpty
                        ? localizations.navigationProfile
                        : profile.fullName,
                    subtitle: profile.email ?? '',
                    lines: <String?>[
                      profile.phoneNumber,
                      profile.address,
                      profile.city,
                      profile.zipCode,
                      profile.country,
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String?> lines;

  const _ProfileCard({
    required this.title,
    required this.subtitle,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final rows = lines.whereType<String>().where((line) => line.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.heading3),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Text(subtitle, style: AppTypography.bodyMedium),
          ],
          const SizedBox(height: AppDimensions.spacingSm),
          ...rows.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
              child: Text(
                line,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
