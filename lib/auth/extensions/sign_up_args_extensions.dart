import 'package:shelf_api/auth/models/sign_up_args.dart';
import 'package:supabase/supabase.dart';

extension SignUpArgsExtensions on SignUpArgs {
  AdminUserAttributes toAdminUserAttributes() {
    return AdminUserAttributes(
      email: email,
      password: password,
      emailConfirm: true,
    );
  }
}
