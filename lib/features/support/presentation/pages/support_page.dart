import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const String _supportEmail = 'waslacrmteam@gmail.com';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimensions.paddingXs,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          localizations.supportPageTitle,
          style: AppTypography.heading3,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppDimensions.paddingLg,
                AppDimensions.spacingMd,
                AppDimensions.paddingLg,
                AppDimensions.paddingXl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.04),
                      _SupportHeroCard(
                        title: localizations.supportPageTitle,
                        description: localizations.supportPageDescription,
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      const _SupportEmailCard(email: _supportEmail),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SupportHeroCard extends StatelessWidget {
  final String title;
  final String description;

  const _SupportHeroCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.brandRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.brandRed,
              size: AppDimensions.iconSizeLg,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(title, style: AppTypography.heading2),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportEmailCard extends StatelessWidget {
  final String email;

  const _SupportEmailCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        onTap: () => _openEmail(email),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            border: Border.all(
              color: AppColors.divider.withValues(alpha: 0.75),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: AppDimensions.iconSizeXl,
                height: AppDimensions.iconSizeXl,
                decoration: BoxDecoration(
                  color: AppColors.brandRed.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: AppColors.brandRed,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              const Icon(
                Icons.open_in_new_rounded,
                color: AppColors.textSecondary,
                size: AppDimensions.iconSizeSm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
