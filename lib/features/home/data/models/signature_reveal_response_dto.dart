import 'json_helpers.dart';

class SignatureRevealResponseDto {
  final String? digitalSignature;

  const SignatureRevealResponseDto({this.digitalSignature});

  factory SignatureRevealResponseDto.fromJson(Map<String, dynamic> json) {
    return SignatureRevealResponseDto(
      digitalSignature: asString(json['digitalSignature']),
    );
  }
}
