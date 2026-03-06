import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';

/// A 6-digit OTP input built on the [Pinput] package.
///
/// Direction is always LTR regardless of the ambient locale / text-direction,
/// so the boxes are always rendered left-to-right (digit 1 on the left, digit 6
/// on the right) even when the app language is Arabic.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.onChanged,
    this.onCompleted,
    this.hasError = false,
  });

  /// Called whenever any digit changes. Provides [index] and [value].
  /// [value] is empty when the digit is cleared.
  final void Function(int index, String value) onChanged;

  /// Called when all 6 digits are filled. Provides the concatenated OTP string.
  final void Function(String otp)? onCompleted;

  /// When true, all boxes render with the error border colour.
  final bool hasError;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  static const int _otpLength = 6;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Derives (index, value) pairs from the full OTP string and fires
  /// [onChanged] for every position so downstream cubits stay in sync.
  void _fireOnChanged(String otp) {
    for (int i = 0; i < _otpLength; i++) {
      final value = i < otp.length ? otp[i] : '';
      widget.onChanged(i, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double boxSize = 44;
    const double borderRadius = 8;

    final BorderRadius radius = BorderRadius.circular(borderRadius);

    final defaultTheme = PinTheme(
      width: boxSize,
      height: boxSize,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: widget.hasError ? AppColors.error : AppColors.divider,
        ),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: widget.hasError ? AppColors.error : AppColors.brandRed,
          width: 2,
        ),
      ),
    );

    final filledTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.brandRed.withOpacity(  0.3),
        borderRadius: radius,
        border: Border.all(
          color: widget.hasError ? AppColors.error : AppColors.brandRed,
        ),
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        border: Border.all(color: AppColors.error),
      ),
    );

    // Wrap in Directionality(LTR) so box order is always left→right,
    // regardless of whether the app is running in Arabic/RTL mode.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: _controller,
        length: _otpLength,
        keyboardType: TextInputType.number,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focusedTheme,
        submittedPinTheme: filledTheme,
        errorPinTheme: errorTheme,
        showCursor: true,
        cursor: Container(
          width: 2,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.brandRed,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onChanged: _fireOnChanged,
        onCompleted: widget.onCompleted,
        // Force error state styling when hasError is set externally.
        forceErrorState: widget.hasError,
      ),
    );
  }
}
