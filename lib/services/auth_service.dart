import 'package:http/http.dart' as http;
import 'dart:convert';

// ─────────────────────────────────────────────────────────────────────────────
// AuthService — logout, change password, reset password
// lib/services/auth_service.dart
// ─────────────────────────────────────────────────────────────────────────────

class AuthService {
  static const String _base = 'https://your-api.com/api/auth'; // ← replace

  // POST /api/auth/logout/
  static Future<AuthResult> logout({String? refreshToken}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/logout/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken ?? ''}),
      );
      if (res.statusCode == 200 || res.statusCode == 204) return AuthResult.ok();
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? 'Logout failed');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }

  // POST /api/auth/change-password/  { old_password, new_password }
  static Future<AuthResult> changePassword({
    required String oldPassword,
    required String newPassword,
    String? token,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/change-password/'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'old_password': oldPassword, 'new_password': newPassword}),
      );
      if (res.statusCode == 200) return AuthResult.ok();
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? b['old_password']?[0] ?? 'Failed to change password');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }

  // POST /api/auth/reset-password/  { email, new_password }
  static Future<AuthResult> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/reset-password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      );
      if (res.statusCode == 200) return AuthResult.ok();
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? 'Failed to reset password');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }
}

class AuthResult {
  final bool success;
  final String? error;
  AuthResult.ok()       : success = true,  error = null;
  AuthResult.err(this.error) : success = false;
}