class PlayerResponse {
  final int id;
  final String fullName;

  PlayerResponse({
    required this.id,
    required this.fullName,
  });

  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    return PlayerResponse(
      id: json['id'],
      fullName: json['full_name'],
    );
  }
}
