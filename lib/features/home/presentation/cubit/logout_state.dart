class LogoutState {
  final bool isLoggingOutCurrent;
  final bool isLoggingOutAll;
  final String? errorMessage;

  const LogoutState({
    this.isLoggingOutCurrent = false,
    this.isLoggingOutAll = false,
    this.errorMessage,
  });

  LogoutState copyWith({
    bool? isLoggingOutCurrent,
    bool? isLoggingOutAll,
    String? errorMessage,
  }) {
    return LogoutState(
      isLoggingOutCurrent: isLoggingOutCurrent ?? this.isLoggingOutCurrent,
      isLoggingOutAll: isLoggingOutAll ?? this.isLoggingOutAll,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
