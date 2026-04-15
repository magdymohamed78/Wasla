enum SignatureStatus { hidden, revealed, locked }

class DigitalSignatureState {
  final SignatureStatus status;
  final String? signatureText;
  final String? errorMessage;
  final bool isLoading;

  const DigitalSignatureState({
    this.status = SignatureStatus.hidden,
    this.signatureText,
    this.errorMessage,
    this.isLoading = false,
  });

  DigitalSignatureState copyWith({
    SignatureStatus? status,
    String? signatureText,
    String? errorMessage,
    bool? isLoading,
  }) {
    return DigitalSignatureState(
      status: status ?? this.status,
      signatureText: signatureText ?? this.signatureText,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  DigitalSignatureState clearSignature() {
    return const DigitalSignatureState();
  }
}
