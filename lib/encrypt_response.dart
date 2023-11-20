class EncrypResponse {
  final String ct;
  final String iv;
  final String s;

  EncrypResponse({
    required this.ct,
    required this.iv,
    required this.s,
  });

  factory EncrypResponse.fromJson(Map<String, dynamic> json) => EncrypResponse(
        ct: json["ct"],
        iv: json["iv"],
        s: json["s"],
      );

  Map<String, dynamic> toJson() => {
        "ct": ct,
        "iv": iv,
        "s": s,
      };
}
