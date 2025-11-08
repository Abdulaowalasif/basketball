class CoachReportModel {
  final int id;
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
  final String playerName; // CHANGED from int to String

  CoachReportModel({
    required this.id,
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

  factory CoachReportModel.fromJson(Map<String, dynamic> json) {
    return CoachReportModel(
      id: json['id'],
      reportTitle: json['report_title'] ?? '',
      overview: json['overview'] ?? '',
      strengths: (json['strengths'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      weaknesses: (json['weaknesses'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      projection: json['projection'] ?? '',
      fieldGoalPercentage:
      (json['field_goal_percentage'] as num?)?.toDouble() ?? 0.0,
      rebounds: json['rebounds'] ?? 0,
      assists: json['assists'] ?? 0,
      stealsAndBlocks: json['steals_and_blocks'] ?? 0,
      createAt: DateTime.tryParse(json['create_at'] ?? '') ?? DateTime.now(),
      updateAt: DateTime.tryParse(json['update_at'] ?? '') ?? DateTime.now(),
      playerName: json['player_name'] ?? '', // FIXED TYPE
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
