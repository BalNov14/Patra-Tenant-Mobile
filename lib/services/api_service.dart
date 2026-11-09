import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://patratenant.my.id/api";
  static const String _tokenKey = "token_login";

  static Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  static Future<Map<String, String>> _authJsonHeaders() async {
    final token = await getToken();

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Map<String, dynamic> _missingTokenResponse() {
    return {
      "statusCode": 401,
      "message": "Token tidak ditemukan, silakan login ulang",
    };
  }

  // =========================
  // LOGIN
  // =========================

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode({"email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // REGISTER TENANT
  // =========================

  static Future registerTenant({
    required String nomorHp,
    required String alamat,
    required String platNomor,
    required String instansi,
    required String? kendaraan,
  }) async {
    if (!await hasToken()) {
      return _missingTokenResponse();
    }

    final response = await http.post(
      Uri.parse("$baseUrl/tenants"),

      headers: await _authJsonHeaders(),

      body: jsonEncode({
        "no_hp": nomorHp,
        "alamat": alamat,
        "plat_nomor": platNomor,
        "asal_instansi": instansi,
        "kendaraan": kendaraan,
      }),
    );

    final data = jsonDecode(response.body);

    if (data is Map<String, dynamic>) {
      return {"statusCode": response.statusCode, ...data};
    }

    return {"statusCode": response.statusCode, "message": response.body};
  }

  // =========================
  // GET TENANT
  // =========================

  static Future<Map<String, dynamic>> getTenantProfile() async {
    if (!await hasToken()) {
      return _missingTokenResponse();
    }

    final response = await http.get(
      Uri.parse("$baseUrl/tenant/profile"),
      headers: await _authJsonHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data is Map<String, dynamic>) {
      return {"statusCode": response.statusCode, ...data};
    }

    return {"statusCode": response.statusCode, "message": response.body};
  }

  static Future<Map<String, dynamic>> getTenant(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/tenants/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Gagal mengambil data tenant");
  }

  // =========================
  // REGISTER USER
  // =========================

  static Future registerUser({
    required String nama,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/store"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "name": nama,
        "email": email,
        "password": password,
        "role": "user",
      }),
    );

    return jsonDecode(response.body);
  }
}
