import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // MongoDB Connection String
  static String? mongoDbUri = dotenv.env['MONGODB_URI'];
  
  // Storage Keys
  static const String tokenKey = "auth_token";
  static const String userRoleKey = "user_role";

}
