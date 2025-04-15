import '../models/user.dart';
import '../utils/file_utils.dart';

class UserController {
  static const String _filename = 'users.json';

  static Future<List<User>> getUsers() async {
    final List<Map<String, dynamic>> jsonList = await FileUtils.readJsonFile(
      _filename,
    );
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  static Future<User?> getUserById(int id) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<User?> getUserByName(String name) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.name == name);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> createUser(User user) async {
    try {
      final users = await getUsers();
      users.add(user);
      await FileUtils.writeJsonFile(
        _filename,
        users.map((u) => u.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUser(User user) async {
    try {
      final users = await getUsers();
      final index = users.indexWhere((u) => u.id == user.id);
      if (index == -1) {
        return false;
      }
      users[index] = user;
      await FileUtils.writeJsonFile(
        _filename,
        users.map((u) => u.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteUser(int id) async {
    try {
      final users = await getUsers();
      users.removeWhere((user) => user.id == id);
      await FileUtils.writeJsonFile(
        _filename,
        users.map((u) => u.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> generateId() async {
    final users = await getUsers();
    if (users.isEmpty) {
      return 1;
    }
    return users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
