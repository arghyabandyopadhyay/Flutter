class TokenModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String userName;
  final String issued;
  final String expires;

  TokenModel({this.accessToken,this.tokenType,this.expiresIn,this.userName, this.issued,this.expires});
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      userName: json['userName'],
      issued: json['.issued'],
      expires: json['.expires'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'userName': userName,
      'issued': issued,
      'expires': expires,
    };
  }
}