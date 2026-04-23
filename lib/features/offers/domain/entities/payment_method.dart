/// Payment method for accepting an offer.
///
/// Maps directly to the API `PaymentMethod` int32 enum:
/// - `0` → COD (Cash on Delivery)
/// - `1` → Online
enum PaymentMethod {
  cod,
  online;

  int toApiValue() => switch (this) {
    PaymentMethod.cod => 0,
    PaymentMethod.online => 1,
  };

  static PaymentMethod fromApiValue(int value) => switch (value) {
    0 => PaymentMethod.cod,
    1 => PaymentMethod.online,
    _ => throw ArgumentError('Unknown PaymentMethod value: $value'),
  };
}
