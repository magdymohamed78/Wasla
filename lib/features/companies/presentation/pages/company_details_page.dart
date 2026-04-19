import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/repositories/customer_reviews_repository.dart';
import '../../../home/domain/use_cases/customer_profile_use_cases.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../../../home/domain/use_cases/role_guard_use_cases.dart';
import '../cubit/company_details_cubit.dart';
import '../cubit/company_details_state.dart';
import '../cubit/company_review_action_cubit.dart';
import '../cubit/company_review_action_state.dart';
import '../widgets/company_review_action_panel.dart';
import '../widgets/company_details_sections.dart';
import '../widgets/write_review_modal.dart';
import '../../../home/presentation/widgets/restricted_request_prompt_card.dart';

class CompanyDetailsPage extends StatelessWidget {
  final int companyId;

  const CompanyDetailsPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CompanyDetailsCubit>(
          create: (context) => CompanyDetailsCubit(
            companyId: companyId,
            getCompanyDetailsUseCase: context.read<GetCompanyDetailsUseCase>(),
            sessionCubit: context.read<SessionCubit>(),
            roleGuardUseCases: context.read<RoleGuardUseCases>(),
          )..loadDetails(),
        ),
        BlocProvider<CompanyReviewActionCubit>(
          create: (context) => CompanyReviewActionCubit(
            companyId: companyId,
            sessionCubit: context.read<SessionCubit>(),
            getCustomerProfileUseCase: context
                .read<GetCustomerProfileUseCase>(),
            reviewsRepository: context.read<CustomerReviewsRepository>(),
          )..loadEligibility(),
        ),
      ],
      child: const _CompanyDetailsView(),
    );
  }
}

class _CompanyDetailsView extends StatelessWidget {
  const _CompanyDetailsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final reviewActionState = context.watch<CompanyReviewActionCubit>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<CompanyDetailsCubit, CompanyDetailsState>(
          listenWhen: (previous, current) =>
              previous.isRestrictionPromptVisible !=
              current.isRestrictionPromptVisible,
          listener: (context, state) {
            if (!state.isRestrictionPromptVisible) {
              return;
            }

            _showRestrictionPromptModal(
              context,
              companyId: state.companyId,
              message: localizations.requestFlowContinuePromptMessage,
              continueLabel: localizations.restrictionContinue,
              cancelLabel: localizations.restrictionCancel,
            );
          },
        ),
        BlocListener<CompanyDetailsCubit, CompanyDetailsState>(
          listenWhen: (previous, current) =>
              previous.pendingRequestServiceCompanyId !=
              current.pendingRequestServiceCompanyId,
          listener: (context, state) {
            final companyId = state.pendingRequestServiceCompanyId;
            if (companyId == null) {
              return;
            }

            context
                .read<CompanyDetailsCubit>()
                .consumeRequestServiceNavigation();
            context.push(
              AppRouter.newServiceRequestLocation(companyId: companyId),
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(localizations.companyDetailsPageTitle),
        ),
        body: SafeArea(
          child: BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
            builder: (context, state) {
              switch (state.detailsStatus) {
                case LoadStatus.initial:
                case LoadStatus.loading:
                  return const _CompanyDetailsSkeleton();
                case LoadStatus.error:
                  return _CompanyDetailsErrorCard(
                    message: _errorMessage(localizations, state),
                    onRetry: context.read<CompanyDetailsCubit>().loadDetails,
                  );
                case LoadStatus.empty:
                case LoadStatus.success:
                  return RefreshIndicator(
                    onRefresh: context.read<CompanyDetailsCubit>().loadDetails,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.paddingMd,
                        AppDimensions.paddingSm,
                        AppDimensions.paddingMd,
                        AppDimensions.paddingMd,
                      ),
                      children: [
                        CompanyDetailsHeaderSection(
                          companyName: state.companyName,
                          unknownCompanyLabel:
                              localizations.companyDetailsUnknownCompany,
                          companyLogoUrl: state.companyLogoUrl,
                          averageRating: state.averageRating,
                          reviewCount: state.reviewCount,
                          locationLine: state.locationLine,
                          noReviewsLabel: localizations.homeNoReviewsYet,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        CompanyContactSection(
                          title: localizations.companyDetailsContactInfo,
                          contactEmail: state.contactEmail,
                          phoneNumber: state.phoneNumber,
                          addressLine: state.addressLine,
                          locationLine: state.locationLine,
                          emptyMessage:
                              localizations.companyDetailsNoContactInfo,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        CompanyServicesSection(
                          title: localizations.companyDetailsServices,
                          services: state.services,
                          emptyMessage:
                              localizations.companyDetailsNoServicesAvailable,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        CompanyReviewsSection(
                          title: localizations
                              .companyDetailsReviewsSectionTitle(
                                state.reviewCount,
                              ),
                          reviews: state.reviews,
                          emptyMessage:
                              localizations.companyDetailsNoReviewsYet,
                          anonymousReviewerLabel:
                              localizations.companyDetailsAnonymousReviewer,
                          noCommentLabel: localizations.companyDetailsNoComment,
                          viewAllLabel:
                              localizations.companyDetailsViewAllReviews,
                          headerAction: _buildReviewHeaderAction(
                            context,
                            reviewActionState,
                          ),
                          actionContent: _buildReviewActionContent(
                            context,
                            reviewActionState,
                          ),
                          maxReviews: 3,
                          onViewAll: () => context.push(
                            AppRouter.companyReviewsLocation(state.companyId),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        PrimaryButton(
                          label: localizations.companyDetailsRequestService,
                          onPressed: context
                              .read<CompanyDetailsCubit>()
                              .onRequestServiceTapped,
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget? _buildReviewHeaderAction(
    BuildContext context,
    CompanyReviewActionState actionState,
  ) {
    if (!actionState.canWriteReview) {
      return null;
    }

    final localizations = AppLocalizations.of(context);

    return ElevatedButton(
      onPressed: actionState.isSubmitting
          ? null
          : () => _onWriteReviewTapped(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandRed,
        foregroundColor: AppColors.surface,
        elevation: 0,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.paddingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        ),
      ),
      child: actionState.isSubmitting
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.surface,
              ),
            )
          : Text(
              localizations.companyReviewsWriteReview,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }

  Widget? _buildReviewActionContent(
    BuildContext context,
    CompanyReviewActionState actionState,
  ) {
    if (!actionState.isCustomerRole) {
      return null;
    }

    if (actionState.canWriteReview) {
      return null;
    }

    final localizations = AppLocalizations.of(context);

    return CompanyReviewActionPanel(
      isEligibilityLoading: actionState.isEligibilityLoading,
      canWriteReview: false,
      showNotConnectedInfo: actionState.shouldShowNotConnectedInfo,
      isSubmitting: actionState.isSubmitting,
      writeReviewLabel: localizations.companyReviewsWriteReview,
      infoMessage: localizations.companyReviewsEligibilityInfo,
      viewProfileLabel: localizations.companyReviewsViewProfile,
      onWriteReview: () {},
      onViewProfile: () => context.go(AppRouter.customerProfile),
    );
  }

  Future<void> _onWriteReviewTapped(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final payload = await WriteReviewModal.show(context);

    if (payload == null || !context.mounted) {
      return;
    }

    final submitResult = await context
        .read<CompanyReviewActionCubit>()
        .submitReview(rating: payload.rating, reviewText: payload.reviewText);

    if (!context.mounted) {
      return;
    }

    if (submitResult.success) {
      await context.read<CompanyDetailsCubit>().loadDetails();
      if (!context.mounted) {
        return;
      }
      ToastUtils.showSuccess(context, localizations.companyReviewsWriteSuccess);
      return;
    }

    ToastUtils.showError(
      context,
      _reviewSubmitErrorMessage(localizations, submitResult),
    );
  }

  String _reviewSubmitErrorMessage(
    AppLocalizations localizations,
    CompanyReviewSubmitResult submitResult,
  ) {
    if (submitResult.errorCode == CompanyReviewSubmitErrorCode.badRequest) {
      return localizations.companyReviewsWriteErrorBadRequest;
    }

    final problemDetail = submitResult.problemDetail?.trim();
    if (problemDetail != null && problemDetail.isNotEmpty) {
      return problemDetail;
    }

    switch (submitResult.errorCode) {
      case CompanyReviewSubmitErrorCode.badRequest:
        return localizations.companyReviewsWriteErrorBadRequest;
      case CompanyReviewSubmitErrorCode.unauthorized:
        return localizations.companyReviewsWriteErrorUnauthorized;
      case CompanyReviewSubmitErrorCode.forbidden:
        return localizations.companyReviewsWriteErrorForbidden;
      case CompanyReviewSubmitErrorCode.notFound:
        return localizations.companyReviewsWriteErrorNotFound;
      case CompanyReviewSubmitErrorCode.conflict:
        return localizations.companyReviewsWriteErrorConflict;
      case CompanyReviewSubmitErrorCode.network:
        return localizations.companyReviewsWriteErrorNetwork;
      case CompanyReviewSubmitErrorCode.server:
      case null:
        return localizations.companyReviewsWriteErrorServer;
    }
  }

  Future<void> _showRestrictionPromptModal(
    BuildContext context, {
    required int companyId,
    required String message,
    required String continueLabel,
    required String cancelLabel,
  }) async {
    final cubit = context.read<CompanyDetailsCubit>();
    final sessionCubit = context.read<SessionCubit>();

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.22),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (dialogContext, _, _) {
        return SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLg,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: RestrictedRequestPromptCard(
                      message: message,
                      continueLabel: continueLabel,
                      cancelLabel: cancelLabel,
                      onContinue: () async {
                        await sessionCubit.saveRequestServicePendingIntent(
                          companyId: companyId,
                          sourceRoute: AppRouter.companyLocation(companyId),
                        );
                        if (!dialogContext.mounted) {
                          return;
                        }
                        Navigator.of(dialogContext).pop();
                        context.push(AppRouter.signIn);
                      },
                      onCancel: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );

    if (context.mounted) {
      cubit.hideRestrictionPrompt();
    }
  }

  String _errorMessage(
    AppLocalizations localizations,
    CompanyDetailsState state,
  ) {
    if (state.errorMessage == CompanyDetailsCubit.invalidCompanyIdError) {
      return localizations.companyDetailsInvalidCompanyId;
    }

    return localizations.companyDetailsLoadFailed;
  }
}

class _CompanyDetailsSkeleton extends StatelessWidget {
  const _CompanyDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        _skeletonBox(height: 180),
        const SizedBox(height: AppDimensions.spacingMd),
        _skeletonBox(height: 120),
        const SizedBox(height: AppDimensions.spacingMd),
        _skeletonBox(height: 160),
        const SizedBox(height: AppDimensions.spacingMd),
        _skeletonBox(height: 240),
        const SizedBox(height: AppDimensions.spacingMd),
        _skeletonBox(height: 48),
      ],
    );
  }

  Widget _skeletonBox({required double height}) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        ),
      ),
    );
  }
}

class _CompanyDetailsErrorCard extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _CompanyDetailsErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                message,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(localizations.networkErrorRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
