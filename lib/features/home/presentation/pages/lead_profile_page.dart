import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/lead_profile_cubit.dart';

class LeadProfilePage extends StatelessWidget {
  const LeadProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeadProfileCubit>(
      create: (context) => LeadProfileCubit(
        getLeadProfileUseCase: context.read<GetLeadProfileUseCase>(),
      )..load(),
      child: const _LeadProfileView(),
    );
  }
}

class _LeadProfileView extends StatelessWidget {
  const _LeadProfileView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<LeadProfileCubit, LeadProfileState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading ||
                state.status == LoadStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == LoadStatus.error || state.profile == null) {
              return _RetryState(
                message: localizations.networkErrorServer,
                onRetry: context.read<LeadProfileCubit>().load,
              );
            }

            final profile = state.profile!;
            final fullName = profile.fullName;

            return RefreshIndicator(
              onRefresh: context.read<LeadProfileCubit>().load,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusLg,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty
                              ? localizations.navigationProfile
                              : fullName,
                          style: AppTypography.heading3,
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        if ((profile.email ?? '').isNotEmpty)
                          Text(profile.email!, style: AppTypography.bodyMedium),
                        const SizedBox(height: AppDimensions.spacingSm),
                        if ((profile.phoneNumber ?? '').isNotEmpty)
                          Text(
                            profile.phoneNumber!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        if ((profile.address ?? '').isNotEmpty)
                          Text(
                            profile.address!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        if ((profile.city ?? '').isNotEmpty ||
                            (profile.country ?? '').isNotEmpty)
                          Text(
                            '${profile.city ?? ''} ${profile.country ?? ''}'
                                .trim(),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
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
