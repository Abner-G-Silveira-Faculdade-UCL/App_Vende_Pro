import '../models/product.dart';
import '../utils/file_utils.dart';

class ProductController {
  static const String _filename = 'products.json';

  static Future<List<Product>> getProducts() async {
    final List<Map<String, dynamic>> jsonList = await FileUtils.readJsonFile(
      _filename,
    );
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product?> getProductById(int id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> createProduct(Product product) async {
    try {
      final products = await getProducts();
      products.add(product);
      await FileUtils.writeJsonFile(
        _filename,
        products.map((p) => p.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProduct(Product product) async {
    try {
      final products = await getProducts();
      final index = products.indexWhere((p) => p.id == product.id);
      if (index == -1) {
        return false;
      }
      products[index] = product;
      await FileUtils.writeJsonFile(
        _filename,
        products.map((p) => p.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      final products = await getProducts();
      products.removeWhere((product) => product.id == id);
      await FileUtils.writeJsonFile(
        _filename,
        products.map((p) => p.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> generateId() async {
    final products = await getProducts();
    if (products.isEmpty) {
      return 1;
    }
    return products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
