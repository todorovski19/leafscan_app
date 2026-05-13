import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import: на web користи localStorage, на останати SharedPreferences
import 'token_storage_stub.dart'
    if (dart.library.html) 'token_storage_web.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthService — JWT auth + token storage
// lib/services/auth_service.dart
//
// FIX: Flutter Web не го праќа токенот правилно преку SharedPreferences поради
// async race conditions. Решението: на Web директно користиме window.localStorage
// преку conditional import (token_storage_web.dart / token_storage_stub.dart).
// ─────────────────────────────────────────────────────────────────────────────

class AuthService {
  static const String _base = 'http://localhost:8000/api';

  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';
  static const _keyUser = 'user_data';

  // ── Token storage ───────────────────────────────────────────────────────────

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    // Web: веднаш синхроно во localStorage — нема race condition
    setTokenInLocalStorage(_keyAccess, access);
    setTokenInLocalStorage(_keyRefresh, refresh);

    // Сите платформи: и во SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccess, access);
    await prefs.setString(_keyRefresh, refresh);
  }

  static Future<String?> getAccessToken() async {
    // На Web: прво провери localStorage директно (синхроно, без await)
    final webToken = getTokenFromLocalStorage(_keyAccess);
    if (webToken != null && webToken.isNotEmpty) return webToken;

    // Fallback: SharedPreferences (Android/iOS/Desktop)
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccess);
  }

  static Future<String?> getRefreshToken() async {
    final webToken = getTokenFromLocalStorage(_keyRefresh);
    if (webToken != null && webToken.isNotEmpty) return webToken;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefresh);
  }

  static Future<void> clearTokens() async {
    removeTokenFromLocalStorage(_keyAccess);
    removeTokenFromLocalStorage(_keyRefresh);
    removeTokenFromLocalStorage(_keyUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccess);
    await prefs.remove(_keyRefresh);
    await prefs.remove(_keyUser);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Auth headers ────────────────────────────────────────────────────────────
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── POST /api/jwt-auth/register/ ────────────────────────────────────────────
  static Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
        }),
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

  // ── POST /api/jwt-auth/login/ ───────────────────────────────────────────────
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200) {
        final b = jsonDecode(res.body);
        await saveTokens(access: b['access'], refresh: b['refresh']);

        final userJson = jsonEncode(b['user'] ?? {});
        setTokenInLocalStorage(_keyUser, userJson);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUser, userJson);

        return AuthResult.ok(data: b);
      }
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? 'Invalid email or password.');
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
      await clearTokens();
      return AuthResult.ok();
    } catch (_) {
      await clearTokens();
      return AuthResult.ok();
    }
  }

  // ── POST /api/jwt-auth/refresh/ ─────────────────────────────────────────────
  static Future<AuthResult> refreshToken() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh == null) return AuthResult.err('No refresh token');
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );
      if (res.statusCode == 200) {
        final b = jsonDecode(res.body);
        setTokenInLocalStorage(_keyAccess, b['access']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyAccess, b['access']);
        return AuthResult.ok(data: b);
      }
      return AuthResult.err('Session expired. Please log in again.');
    } catch (_) {
      return AuthResult.err('Network error.');
    }
  }

  // ── GET /api/jwt-auth/me/ ───────────────────────────────────────────────────
  static Future<AuthResult> me() async {
    try {
      final headers = await _authHeaders();
      final res = await http.get(
        Uri.parse('$_base/jwt-auth/me/'),
        headers: headers,
      );
      if (res.statusCode == 200) {
        return AuthResult.ok(data: jsonDecode(res.body));
      }
      return AuthResult.err('Failed to get user data.');
    } catch (_) {
      return AuthResult.err('Network error.');
    }
  }

  // ── POST /api/jwt-auth/change-password/ ────────────────────────────────────
  static Future<AuthResult> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final headers = await _authHeaders();
      final res = await http.post(
        Uri.parse('$_base/jwt-auth/change-password/'),
        headers: headers,
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );
      if (res.statusCode == 200) return AuthResult.ok();
      final b = jsonDecode(res.body);
      return AuthResult.err(b['detail'] ?? b['old_password']?[0] ?? 'Failed to change password');
    } catch (_) {
      return AuthResult.err('Network error. Please try again.');
    }
  }

  // ── POST /api/jwt-auth/reset-password/ ─────────────────────────────────────
  static Future<AuthResult> resetPassword({
    required String email,
    required String newPassword,
  }) async {
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
