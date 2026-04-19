import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class WriteReviewPayload {
  final int rating;
  final String? reviewText;

  const WriteReviewPayload({required this.rating, this.reviewText});
}

class WriteReviewModal extends StatefulWidget {
  const WriteReviewModal({super.key});

  static Future<WriteReviewPayload?> show(BuildContext context) {
    return showModalBottomSheet<WriteReviewPayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WriteReviewModal(),
    );
  }

  @override
  State<WriteReviewModal> createState() => _WriteReviewModalState();
}

class _WriteReviewModalState extends State<WriteReviewModal> {
  late final TextEditingController _reviewController;
  double _rating = 0;
  String? _ratingError;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.borderRadiusXxl),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingLg,
              AppDimensions.paddingMd,
              AppDimensions.paddingLg,
              AppDimensions.paddingLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusRound,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Text(
                  localizations.companyReviewsWriteReview,
                  style: AppTypography.heading3,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Text(
                  localizations.myReviewsRatingLabel,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  child: RatingBar.builder(
                    itemSize: 34,
                    initialRating: _rating,
                    minRating: 0,
                    allowHalfRating: false,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB300),
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        _rating = value;
                        _ratingError = null;
                      });
                    },
                  ),
                ),
                if (_ratingError != null) ...[
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    _ratingError!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.spacingMd),
                Text(
                  localizations.myReviewsCommentLabel,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  maxLength: 280,
                  decoration: InputDecoration(
                    hintText: localizations.companyReviewsWriteHint,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMd,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMd,
                      ),
                      borderSide: const BorderSide(color: AppColors.brandRed),
                    ),
                    counterStyle: AppTypography.bodySmall,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(localizations.myReviewsCancel),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandRed,
                          foregroundColor: AppColors.surface,
                        ),
                        child: Text(localizations.companyReviewsWriteSubmit),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final localizations = AppLocalizations.of(context);

    if (_rating < 1 || _rating > 5) {
      setState(() {
        _ratingError = localizations.myReviewsValidationRatingRequired;
      });
      return;
    }

    final reviewText = _reviewController.text.trim();

    Navigator.of(context).pop(
      WriteReviewPayload(
        rating: _rating.round(),
        reviewText: reviewText.isEmpty ? null : reviewText,
      ),
    );
  }
}
