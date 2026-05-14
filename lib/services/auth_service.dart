import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthService — JWT auth + token storage
// ─────────────────────────────────────────────────────────────────────────────

class AuthService {
  static const String _base = 'http://localhost:8000/api';

  // In-memory cache so Flutter Web can also access tokens
  static String? _accessTokenCache;
  static String? _refreshTokenCache;

  // ── Token storage ───────────────────────────────────────────────────────────
  static Future<void> saveTokens({required String access, required String refresh}) async {
    _accessTokenCache  = access;
    _refreshTokenCache = refresh;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token',  access);
      await prefs.setString('refresh_token', refresh);
    } catch (_) {}
  }

  static Future<String?> getAccessToken() async {
    if (_accessTokenCache != null) return _accessTokenCache;
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessTokenCache = prefs.getString('access_token');
      return _accessTokenCache;
    } catch (_) { return null; }
  }

  static Future<String?> getRefreshToken() async {
    if (_refreshTokenCache != null) return _refreshTokenCache;
    try {
      final prefs = await SharedPreferences.getInstance();
      _refreshTokenCache = prefs.getString('refresh_token');
      return _refreshTokenCache;
    } catch (_) { return null; }
  }

  static Future<void> clearTokens() async {
    _accessTokenCache  = null;
    _refreshTokenCache = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_data');
    } catch (_) {}
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── POST /api/jwt-auth/login/ ───────────────────────────────────────────────
  static Future<AuthResult> login({required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200) {
        final b = jsonDecode(res.body);
        await saveTokens(access: b['access'], refresh: b['refresh']);
        return AuthResult.ok(data: b);
      }
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? 'Invalid email or password.');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }

  // ── POST /api/jwt-auth/register/ ────────────────────────────────────────────
  static Future<AuthResult> register({required String fullName, required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'full_name': fullName, 'email': email, 'password': password}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final b = jsonDecode(res.body);
        await saveTokens(access: b['access'], refresh: b['refresh']);
        return AuthResult.ok(data: b);
      }
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? b['email']?[0] ?? 'Registration failed');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }

  // ── POST /api/jwt-auth/logout/ ──────────────────────────────────────────────
  static Future<AuthResult> logout() async {
    try {
      final refresh = await getRefreshToken();
      final headers = await _authHeaders();
      await http.post(
        Uri.parse('$_base/jwt-auth/logout/'),
        headers: headers,
        body: jsonEncode({'refresh': refresh ?? ''}),
      );
    } catch (_) {}
    await clearTokens();
    return AuthResult.ok();
  }

  // ── GET /api/jwt-auth/me/ ───────────────────────────────────────────────────
  static Future<AuthResult> me() async {
    try {
      final headers = await _authHeaders();
      final res = await http.get(Uri.parse('$_base/jwt-auth/me/'), headers: headers);
      if (res.statusCode == 200) return AuthResult.ok(data: jsonDecode(res.body));
      return AuthResult.err('Failed to get user data.');
    } catch (_) {
      return AuthResult.err('Network error.');
    }
  }

  // ── POST /api/jwt-auth/change-password/ ────────────────────────────────────
  static Future<AuthResult> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      final headers = await _authHeaders();
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/change-password/'),
        headers: headers,
        body: jsonEncode({'old_password': oldPassword, 'new_password': newPassword}),
      );
      if (res.statusCode == 200) return AuthResult.ok();
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? 'Failed to change password');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }

  // ── POST /api/jwt-auth/reset-password/ ─────────────────────────────────────
  static Future<AuthResult> resetPassword({required String email, required String newPassword}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/reset-password/'),
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
  final Map<String, dynamic>? data;
  AuthResult.ok({this.data}) : success = true, error = null;
  AuthResult.err(this.error) : success = false, data = null;
}
