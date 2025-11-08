import 'package:basketball/features/auth/views/sign_up_screen.dart';
import 'package:get/get.dart';

// App routes
import 'package:basketball/routes/routes_name.dart';

// Auth feature
import '../features/auth/views/compact_screen.dart';
import '../features/auth/views/forgot_password.dart';
import '../features/auth/views/home_screen.dart';
import '../features/auth/views/reset_password.dart';
import '../features/auth/views/sign_in_screen.dart';
import '../features/auth/views/verify_email.dart';

// Coach feature
import '../features/coach/team_info/team_info_screen.dart';
import '../features/coach/views/team_scouting_report_screen.dart';
import '../features/coach/upload_film/upload_film_screen.dart';

// Player feature
import 'package:basketball/features/player_info/screen/player_info_screen.dart';
import 'package:basketball/features/profile/views/profile_screen.dart';

// Game/process feature
import 'package:basketball/features/process_game/process_game_screen.dart';
import 'package:basketball/features/upload_game/upload_game_screen.dart';

// Scouting feature
import 'package:basketball/features/scounting_context/scouting_context_screen.dart';

// Report feature
import '../features/report/views/report_list_screen.dart';
import 'package:basketball/features/report/views/report_screen.dart';

// Error
import 'package:basketball/features/error/error_screen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    // Auth routes
    GetPage(
      name: RoutesName.signIn,
      page: () => SignInScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.signUp,
      page: () => SignUpScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.forgotPass,
      page: () => ForgotPasswordScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.verifyCode,
      page: () => VerifyEmailScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.resetPass,
      page: () => ResetPasswordScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.compact,
      page: () => const CompactScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Coach routes
    GetPage(
      name: RoutesName.uploadFile,
      page: () => UploadFilmScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.teamInfo,
      page: () => TeamInfoScreen(),
    ),
    GetPage(
      name: RoutesName.scoutingReport,
      page: () => TeamScoutingReportScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Player routes
    GetPage(
      name: RoutesName.playerInfo,
      page: () => const PlayerInfoScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.profile,
      page: () => ProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Coach routes
    GetPage(
      name: RoutesName.coachInfo,
      page: () => TeamInfoScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Game/process routes
    GetPage(
      name: RoutesName.processGame,
      page: () => const ProcessGameScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.uploadGame,
      page: () => const UploadGameScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Scouting context
    GetPage(
      name: RoutesName.scoutingContext,
      page: () => const ScoutingContextScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Report routes
    GetPage(
      name: RoutesName.reportList,
      page: () => ReportListScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RoutesName.viewReport,
      page: () => ReportScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Error route
    GetPage(
      name: RoutesName.error,
      page: () => const ErrorScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
  ];
}