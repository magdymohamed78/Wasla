import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/session/session_cubit.dart';
import '../../../../../core/session/session_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/types/load_status.dart';
import '../../../../offers/domain/entities/offer_filter.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import 'dashboard_metric_card.dart';
import 'dashboard_section_states.dart';

class CustomerDashboardSection extends StatefulWidget {
  const CustomerDashboardSection({
    super.key,
    this.onTotalOffersTap,
    this.onAcceptedOffersTap,
    this.onPendingOffersTap,
    this.onMyReviewsTap,
  });

  final VoidCallback? onTotalOffersTap;
  final VoidCallback? onAcceptedOffersTap;
  final VoidCallback? onPendingOffersTap;
  final VoidCallback? onMyReviewsTap;

  @override
  State<CustomerDashboardSection> createState() =>
      _CustomerDashboardSectionState();
}

class _CustomerDashboardSectionState extends State<CustomerDashboardSection> {
  bool _isNavigating = false;
  bool _initialCustomerLoadTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureInitialCustomerLoad();
  }

  void _ensureInitialCustomerLoad() {
    final sessionState = context.read<SessionCubit>().state;
    if (sessionState.role != SessionRole.customer) {
      _initialCustomerLoadTriggered = false;
      return;
    }

    if (_initialCustomerLoadTriggered) {
      return;
    }

    _initialCustomerLoadTriggered = true;
    unawaited(context.read<DashboardCubit>().load());
  }

  Future<void> _handleProtectedNavigation(
    Future<void> Function() action,
  ) async {
    if (_isNavigating) {
      return;
    }

    setState(() => _isNavigating = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }

  Future<void> _onTotalOffersTap(BuildContext context) async {
    if (widget.onTotalOffersTap != null) {
      widget.onTotalOffersTap!();
      return;
    }
    context.go(AppRouter.customerOffersFilteredLocation(OfferFilter.all));
  }

  Future<void> _onAcceptedOffersTap(BuildContext context) async {
    if (widget.onAcceptedOffersTap != null) {
      widget.onAcceptedOffersTap!();
      return;
    }
    context.go(AppRouter.customerOffersFilteredLocation(OfferFilter.accepted));
  }

  Future<void> _onPendingOffersTap(BuildContext context) async {
    if (widget.onPendingOffersTap != null) {
      widget.onPendingOffersTap!();
      return;
    }
    context.go(AppRouter.customerOffersFilteredLocation(OfferFilter.pending));
  }

  Future<void> _onMyReviewsTap(BuildContext context) async {
    if (widget.onMyReviewsTap != null) {
      widget.onMyReviewsTap!();
      return;
    }
    await context.push(AppRouter.customerMyReviewsLocation());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listenWhen: (previous, current) => previous.role != current.role,
      listener: (context, sessionState) {
        if (sessionState.role == SessionRole.customer) {
          _initialCustomerLoadTriggered = true;
          unawaited(context.read<DashboardCubit>().load());
          return;
        }

        _initialCustomerLoadTriggered = false;
      },
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          if (sessionState.role != SessionRole.customer) {
            return const SizedBox.shrink();
          }

          return BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              Widget content;

              if (state.status == LoadStatus.initial ||
                  state.status == LoadStatus.loading) {
                content = const DashboardSectionSkeleton();
                return Column(
                  children: [
                    content,
                    const SizedBox(height: AppDimensions.spacingLg),
                  ],
                );
              }

              if (state.status == LoadStatus.error) {
                content = DashboardSectionInlineError(
                  onRetry: context.read<DashboardCubit>().retry,
                );
                return Column(
                  children: [
                    content,
                    const SizedBox(height: AppDimensions.spacingLg),
                  ],
                );
              }

              final localizations = AppLocalizations.of(context);
              final metrics = [
                _DashboardMetric(
                  label: localizations.homeDashboardTotalOffers,
                  value: state.totalOffers,
                  icon: Icons.local_offer_outlined,
                  color: AppColors.statusOfferSent,
                  onTap: () => _handleProtectedNavigation(
                    () => _onTotalOffersTap(context),
                  ),
                ),
                _DashboardMetric(
                  label: localizations.homeDashboardAcceptedOffers,
                  value: state.acceptedOffers,
                  icon: Icons.task_alt_outlined,
                  color: AppColors.statusAccepted,
                  onTap: () => _handleProtectedNavigation(
                    () => _onAcceptedOffersTap(context),
                  ),
                ),
                _DashboardMetric(
                  label: localizations.homeDashboardPendingOffers,
                  value: state.pendingOffers,
                  icon: Icons.pending_actions_outlined,
                  color: AppColors.statusPending,
                  onTap: () => _handleProtectedNavigation(
                    () => _onPendingOffersTap(context),
                  ),
                ),
                _DashboardMetric(
                  label: localizations.homeDashboardMyReviews,
                  value: state.myReviews,
                  icon: Icons.reviews_rounded,
                  color: AppColors.brandRed,
                  onTap: () => _handleProtectedNavigation(
                    () => _onMyReviewsTap(context),
                  ),
                ),
              ];

              content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.hasPartialData) ...[
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        bottom: AppDimensions.spacingSm,
                      ),
                      child: Text(
                        localizations.homeDashboardLoadFailed,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final isTablet = width >= 720;
                      final isMedium = width >= 540 && width < 720;
                      final crossAxisCount = isTablet ? 4 : (isMedium ? 3 : 2);
                      final spacing = isMedium || isTablet
                          ? AppDimensions.spacingMd
                          : AppDimensions.spacingSm;
                      final childAspectRatio = isTablet
                          ? 1.65
                          : (isMedium ? 1.45 : 1.3);

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: metrics.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final metric = metrics[index];
                          final durationMs = 240 + (index * 70);

                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: durationMs),
                            curve: Curves.easeOutCubic,
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 12 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: DashboardMetricCard(
                              label: metric.label,
                              value: metric.value,
                              icon: metric.icon,
                              iconColor: metric.color,
                              onTap: metric.onTap,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );

              return Column(
                children: [
                  content,
                  const SizedBox(height: AppDimensions.spacingLg),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _DashboardMetric {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DashboardMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });
}
