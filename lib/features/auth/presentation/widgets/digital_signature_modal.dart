import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../cubit/signature_modal_cubit.dart';
import '../cubit/signature_modal_state.dart';

class DigitalSignatureModal extends StatelessWidget {
  final VoidCallback onOkPressed;

  const DigitalSignatureModal({super.key, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: BlocBuilder<SignatureModalCubit, SignatureModalState>(
        builder: (context, state) {
          final isDownloaded = state.status == SignatureModalStatus.downloaded;

          return Dialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            ),
            elevation: 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Icon
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingSm),
                    decoration: BoxDecoration(
                      color: isDownloaded
                          ? Colors.green.withOpacity(0.1)
                          : AppColors.brandRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDownloaded
                          ? Icons.check_circle_outline
                          : Icons.vpn_key_outlined,
                      color: isDownloaded ? Colors.green : AppColors.brandRed,
                      size: AppDimensions.iconSizeLg,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  // Title
                  Text(
                    localizations.signatureModalTitle,
                    style: AppTypography.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  // Guidance text
                  Text(
                    localizations.signatureModalGuidance,
                    style: AppTypography.bodySmall.copyWith(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // Signature Viewer
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusLg,
                      ),
                      border: Border.all(
                        color: isDownloaded
                            ? Colors.green.withOpacity(0.3)
                            : AppColors.divider,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: AppDimensions.paddingMd,
                            bottom: AppDimensions.paddingMd,
                            left: AppDimensions.paddingMd,
                            right: isDownloaded
                                ? AppDimensions.paddingMd
                                : 56.0,
                          ),
                          child: SelectableText(
                            isDownloaded
                                ? '\u2022' * state.signature.length
                                : state.signature,
                            style: AppTypography.bodyMedium.copyWith(
                              fontFamily: 'monospace',
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        // Copy Button Overlay (if not downloaded/redacted)
                        if (!isDownloaded)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(
                                Icons.copy,
                                size: AppDimensions.iconSizeSm,
                              ),
                              color: AppColors.textSecondary,
                              tooltip: 'Copy to clipboard',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: state.signature),
                                );
                                ToastUtils.showSuccess(
                                  context,
                                  localizations.signatureModalCopySuccess,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  // Error Message
                  if (state.status == SignatureModalStatus.downloadError)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingSm,
                        horizontal: AppDimensions.paddingMd,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.spacingMd,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: AppDimensions.iconSizeSm,
                          ),
                          const SizedBox(width: AppDimensions.spacingSm),
                          Expanded(
                            child: Text(
                              localizations.signatureModalDownloadError,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Download Button
                  if (state.status == SignatureModalStatus.downloading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingSm,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.brandRed,
                        ),
                      ),
                    )
                  else if (!isDownloaded)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download_rounded),
                      label: Text(localizations.signatureModalDownloadButton),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.brandRed,
                        side: const BorderSide(color: AppColors.brandRed),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingSm,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMd,
                          ),
                        ),
                      ),
                      onPressed: () => context
                          .read<SignatureModalCubit>()
                          .downloadSignature(),
                    ),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // OK Button
                  Semantics(
                    label: localizations.signatureModalOk,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDownloaded
                            ? AppColors.brandRed
                            : AppColors.buttonSecondary,
                        foregroundColor: isDownloaded
                            ? Colors.white
                            : AppColors.textSecondary,
                        elevation: isDownloaded ? 2 : 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMd,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMd,
                          ),
                        ),
                      ),
                      onPressed: isDownloaded ? onOkPressed : null,
                      child: Text(
                        localizations.signatureModalOk,
                        style: AppTypography.buttonLabel.copyWith(
                          color: isDownloaded
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
