enum SignatureModalStatus { idle, downloading, downloaded, downloadError }

class SignatureModalState {
  final String signature;
  final SignatureModalStatus status;
  final String? errorMessage;

  const SignatureModalState({
    required this.signature,
    this.status = SignatureModalStatus.idle,
    this.errorMessage,
  });

  SignatureModalState copyWith({
    String? signature,
    SignatureModalStatus? status,
    String? errorMessage,
  }) {
    return SignatureModalState(
      signature: signature ?? this.signature,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
