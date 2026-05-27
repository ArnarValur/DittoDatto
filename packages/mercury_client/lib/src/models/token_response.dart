import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

/// Response from `POST /auth/dev-login`.
///
/// Contains a JWT access token, token type, and expiry duration.
@JsonSerializable()
class TokenResponse {
  const TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  /// JWT access token.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Token type (usually "bearer").
  @JsonKey(name: 'token_type')
  final String tokenType;

  /// Token lifetime in seconds.
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}
