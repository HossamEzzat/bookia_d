import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class AuthLocalDataSource {
  static const _tokenKey = 'auth_token';
  static const _nameKey = 'user_name';
  static const _idKey = 'user_id';

  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, user.token);
    await prefs.setString(_nameKey, user.name);
    await prefs.setInt(_idKey, user.id);
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final name = prefs.getString(_nameKey);
    final id = prefs.getInt(_idKey);

    if (token != null && token.isNotEmpty) {
      return UserModel(id: id ?? 0, name: name ?? '', token: token);
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_idKey);
  }
}
