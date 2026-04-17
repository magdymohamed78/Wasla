import 'package:flutter/material.dart';
import 'package:waslaapp/core/theme/app_dimensions.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class DiscoveryFloatingModal extends StatelessWidget {
  final SessionRole role;
  final VoidCallback onAllCompaniesTap;
  final VoidCallback onRecommendedCompaniesTap;
  final VoidCallback onTrendingCompaniesTap;
  final VoidCallback onRequestsTap;
  final VoidCallback onOffersTap;

  const DiscoveryFloatingModal({
    super.key,
    required this.role,
    required this.onAllCompaniesTap,
    required this.onRecommendedCompaniesTap,
    required this.onTrendingCompaniesTap,
    required this.onRequestsTap,
    required this.onOffersTap,
  });

  bool get _showServicesSection => role == SessionRole.customer;

  void _closeAndRun(BuildContext context, VoidCallback action) {
    Navigator.pop(context);
    action();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.borderRadiusXxl),
        topRight: Radius.circular(AppDimensions.borderRadiusXxl),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingLg,
            horizontal: AppDimensions.paddingLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.navigationCompanies,
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _ModalRow(
                icon: Icons.business,
                title: localizations.homeAllCompanies,
                onTap: () => _closeAndRun(context, onAllCompaniesTap),
              ),
              _ModalRow(
                icon: Icons.thumb_up_alt_outlined,
                title: localizations.homeRecommendedCompanies,
                onTap: () => _closeAndRun(context, onRecommendedCompaniesTap),
              ),
              _ModalRow(
                icon: Icons.trending_up,
                title: localizations.homeTrendingCompanies,
                onTap: () => _closeAndRun(context, onTrendingCompaniesTap),
              ),
              if (_showServicesSection) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: AppColors.background, thickness: 1.5),
                ),
                Text(
                  localizations.homeServices,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _ModalRow(
                  icon: Icons.assignment_outlined,
                  title: localizations.navigationRequests,
                  onTap: () => _closeAndRun(context, onRequestsTap),
                ),
                _ModalRow(
                  icon: Icons.local_offer_outlined,
                  title: localizations.navigationOffers,
                  onTap: () => _closeAndRun(context, onOffersTap),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ModalRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.brandRed.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.brandRed, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyLarge.copyWith(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
