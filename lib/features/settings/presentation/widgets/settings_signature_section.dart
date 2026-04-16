import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/digital_signature_cubit.dart';
import '../cubit/digital_signature_state.dart';
import 'signature_box.dart';
import 'signature_password_modal.dart';

class SettingsSignatureSection extends StatelessWidget {
  const SettingsSignatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DigitalSignatureCubit, DigitalSignatureState>(
      builder: (context, state) {
        final isRevealed = state.status == SignatureStatus.revealed;
        final isLocked = state.status == SignatureStatus.locked;

        return SignatureBox(
          signatureText: state.signatureText,
          isRevealed: isRevealed,
          isLocked: isLocked,
          errorMessage: isLocked ? state.errorMessage : null,
          onTap: () => _openPasswordModal(context),
        );
      },
    );
  }

  void _openPasswordModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<DigitalSignatureCubit>(),
        child: const SignaturePasswordModal(),
      ),
    );
  }
}
