class PlayerInfo {
  final String playerName;
  final String jerseyNumber;
  final String height;
  final String jerseyColor;
  final String position;
  final String classYear;
  final String gameContext;
  final String teamType;
  final String gender;
  final String opponentTeam;
  final String performanceNote;
  final String tournamentName;
  final String gameResult;
  final String opponentFaced;
  final String scoreOrMargin;
  final String gameFlowDetails;

  PlayerInfo({
    required this.tournamentName,
    required this.gameResult,
    required this.opponentFaced,
    required this.scoreOrMargin,
    required this.gameFlowDetails,
    required this.playerName,
    required this.jerseyNumber,
    required this.height,
    required this.jerseyColor,
    required this.position,
    required this.classYear,
    required this.gameContext,
    required this.teamType,
    required this.gender,
    required this.opponentTeam,
    required this.performanceNote,
  });
}
