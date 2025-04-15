import '../models/customer.dart';
import '../utils/file_utils.dart';

class CustomerController {
  static const String _filename = 'customers.json';

  static Future<List<Customer>> getCustomers() async {
    final List<Map<String, dynamic>> jsonList = await FileUtils.readJsonFile(
      _filename,
    );
    return jsonList.map((json) => Customer.fromJson(json)).toList();
  }

  static Future<Customer?> getCustomerById(int id) async {
    final customers = await getCustomers();
    try {
      return customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> createCustomer(Customer customer) async {
    try {
      final customers = await getCustomers();
      customers.add(customer);
      await FileUtils.writeJsonFile(
        _filename,
        customers.map((c) => c.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateCustomer(Customer customer) async {
    try {
      final customers = await getCustomers();
      final index = customers.indexWhere((c) => c.id == customer.id);
      if (index == -1) {
        return false;
      }
      customers[index] = customer;
      await FileUtils.writeJsonFile(
        _filename,
        customers.map((c) => c.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteCustomer(int id) async {
    try {
      final customers = await getCustomers();
      customers.removeWhere((customer) => customer.id == id);
      await FileUtils.writeJsonFile(
        _filename,
        customers.map((c) => c.toJson()).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> generateId() async {
    final customers = await getCustomers();
    if (customers.isEmpty) {
      return 1;
    }
    return customers.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
