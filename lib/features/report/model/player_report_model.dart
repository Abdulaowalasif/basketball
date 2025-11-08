class PlayerReportModel {
  final int id;
  final String playerFullName;
  final String reportTitle;
  final String overview;
  final List<String> strengths;
  final List<String> weaknesses;
  final String projection;
  final double fieldGoalPercentage;
  final int rebounds;
  final int assists;
  final int stealsAndBlocks;
  final DateTime createAt;
  final DateTime updateAt;
  final int playerName; // This looks like player ID

  PlayerReportModel({
    required this.id,
    required this.playerFullName,
    required this.reportTitle,
    required this.overview,
    required this.strengths,
    required this.weaknesses,
    required this.projection,
    required this.fieldGoalPercentage,
    required this.rebounds,
    required this.assists,
    required this.stealsAndBlocks,
    required this.createAt,
    required this.updateAt,
    required this.playerName,
  });

  factory PlayerReportModel.fromJson(Map<String, dynamic> json) {
    return PlayerReportModel(
      id: json['id'],
      playerFullName: json['player_full_name'],
      reportTitle: json['report_title'],
      overview: json['overview'],
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      projection: json['projection'],
      fieldGoalPercentage: (json['field_goal_percentage'] as num).toDouble(),
      rebounds: json['rebounds'],
      assists: json['assists'],
      stealsAndBlocks: json['steals_and_blocks'],
      createAt: DateTime.parse(json['create_at']),
      updateAt: DateTime.parse(json['update_at']),
      playerName: json['player_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_full_name': playerFullName,
      'report_title': reportTitle,
      'overview': overview,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'projection': projection,
      'field_goal_percentage': fieldGoalPercentage,
      'rebounds': rebounds,
      'assists': assists,
      'steals_and_blocks': stealsAndBlocks,
      'create_at': createAt.toIso8601String(),
      'update_at': updateAt.toIso8601String(),
      'player_name': playerName,
    };
  }
}
