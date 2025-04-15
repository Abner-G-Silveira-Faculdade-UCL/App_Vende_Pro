import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  static Future<List<Map<String, dynamic>>> readJsonFile(
    String filename,
  ) async {
    try {
      final file = await _localFile(filename);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  static Future<void> writeJsonFile(
    String filename,
    List<Map<String, dynamic>> data,
  ) async {
    final file = await _localFile(filename);
    await file.writeAsString(json.encode(data));
  }
}
