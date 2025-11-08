class ApiEndpoints {
  static const String baseUrl = 'https://jberger.dsrt321.online/';
  // Auth endpoints
  static const String signUp = '${baseUrl}api/auth/register/';
  static const String login = '${baseUrl}api/auth/login/';
  static const String forgotPassword = '${baseUrl}api/auth/forgot-password/';
  static const String setNewPassword = '${baseUrl}api/auth/set_new_password/';
  static const String changePassword = '${baseUrl}api/auth/change-password/';
  static const String logout = '${baseUrl}api/auth/logout/';

  // Player endpoints
  static const String userLists = '${baseUrl}player/user-list/';
  static const String createReport = '${baseUrl}player/create/';
  static const String getReportList = '${baseUrl}player/report-list/';
  static const String getReportDetails = '${baseUrl}player/report-detail/';
  static const String playerReportPdf = '${baseUrl}player/report/';
  static const String playerSendReportMail = '${baseUrl}player/report/send-mail/';

  // Coach/team endpoints
  static const String createReportCoach = '${baseUrl}coach/team/information/create/';
  static const String teamInfoSubmission = '${baseUrl}coach/team/information/create/';
  static const String getReportListCoach = '${baseUrl}coach/team/scouting/';
  static const String submitTeamData = '${baseUrl}team/submit';
  static const String coachReportPdf = '${baseUrl}coach/team/scouting/pdf/';
  static const String coachSendReportMail = '${baseUrl}coach/team/scouting/email/';

  // Misc endpoints
  static const String opponentsList = '${baseUrl}opponents/list';
  static const String jerseyColors = '${baseUrl}jersey/colors';
}