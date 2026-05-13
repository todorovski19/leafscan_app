import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leafscan_app/services/auth_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ApiService — all API calls except auth
// ─────────────────────────────────────────────────────────────────────────────

class ApiService {
  static const String _base = 'http://localhost:8000/api';

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── User ───────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getMe() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/jwt-auth/me/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return null;
    } catch (_) { return null; }
  }

  // ── Analyses ───────────────────────────────────────────────────────────────
  static Future<List<dynamic>> getMyAnalyses() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/analyses/my/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (_) { return []; }
  }

  static Future<List<dynamic>> getMyRecentAnalyses() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/analyses/my/recent/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (_) { return []; }
  }

  static Future<Map<String, dynamic>?> getMySummary() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/analyses/my/summary/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return null;
    } catch (_) { return null; }
  }

  // ── Diseases ───────────────────────────────────────────────────────────────
  static Future<List<dynamic>> getDiseases() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/diseases/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (_) { return []; }
  }

  static Future<Map<String, dynamic>?> getDiseaseById(int id) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/diseases/$id/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return null;
    } catch (_) { return null; }
  }

  static Future<List<dynamic>> getDiseaseTreatments(int id) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/diseases/$id/treatments/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (_) { return []; }
  }

  // ── Plants ─────────────────────────────────────────────────────────────────
  static Future<List<dynamic>> getPlants() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/plants/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (_) { return []; }
  }

  static Future<Map<String, dynamic>?> getPlantById(int id) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/plants/$id/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return null;
    } catch (_) { return null; }
  }

  static Future<List<dynamic>> getPlantTopDiseases(int id) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/plants/$id/top-diseases/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (_) { return []; }
  }
}
