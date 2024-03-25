import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf_api/auth/extensions/auth_exception_extensions.dart';
import 'package:shelf_api/auth/extensions/sign_up_args_extensions.dart';
import 'package:shelf_api/auth/models/app_auth_response.dart';
import 'package:shelf_api/auth/models/app_user.dart';
import 'package:shelf_api/auth/models/sign_in_args.dart';
import 'package:shelf_api/auth/models/sign_up_args.dart';
import 'package:shelf_api/common/config/app_config.dart';
import 'package:shelf_api/common/errors/app_error.dart';
import 'package:supabase/supabase.dart';

class AuthClient {
  const AuthClient(this._supabase);
  final SupabaseClient _supabase;

  Future<AppAuthResponse> signUp(SignUpArgs args) async {
    try {
      final response = await _supabase.auth.admin.createUser(
        args.toAdminUserAttributes(),
      );

      final user = response.user;
      if (user == null) {
        throw RegistrationError();
      }

      return signIn((email: args.email, password: args.password));
    } on AuthException catch (e) {
      throw e.toAppError();
    }
  }

  Future<AppAuthResponse> signIn(SignInArgs args) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: args.email,
        password: args.password,
      );

      final session = response.session;
      if (session == null) {
        throw LoginError();
      }

      return AppAuthResponse(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken!,
      );
    } on AuthException catch (e) {
      throw e.toAppError();
    }
  }

  String validate(String token) {
    final jwt = JWT.tryVerify(
      token,
      SecretKey(AppConfig.instance.supabase.jwtSecret),
    );

    if (jwt == null) {
      throw InvalidTokenError();
    }

    return jwt.subject!;
  }

  Future<AppUser?> findById(String userId) async {
    final response = await _supabase.auth.admin.getUserById(userId);
    final user = response.user;
    if (user == null) {
      return null;
    }

    return AppUser(
      id: user.id,
      email: user.email!,
    );
  }

  Future<AppAuthResponse> refresh(String refreshToken) async {
    try {
      final response = await _supabase.auth
          .setSession(refreshToken)
          .then((_) => _supabase.auth.refreshSession());

      final session = response.session;

      if (session == null) {
        throw InvalidRefreshTokenError();
      }

      return AppAuthResponse(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken!,
      );
    } on AuthException catch (e) {
      throw e.toAppError();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _supabase.auth.admin.deleteUser(userId);
    } on AuthException catch (e) {
      throw e.toAppError();
    }
  }
}
