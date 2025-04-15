import 'package:flutter/material.dart';
import '../controllers/customer_controller.dart';
import '../models/customer.dart';
import 'customer_form_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final customers = await CustomerController.getCustomers();
    setState(() {
      _customers = customers;
    });
  }

  Future<void> _deleteCustomer(Customer customer) async {
    final success = await CustomerController.deleteCustomer(customer.id);
    if (success) {
      await _loadCustomers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente excluído com sucesso!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir cliente.')),
        );
      }
    }
  }

  Future<void> _editCustomer(Customer customer) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormScreen(customer: customer),
      ),
    );

    if (result == true) {
      await _loadCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body:
          _customers.isEmpty
              ? const Center(child: Text('Nenhum cliente cadastrado'))
              : ListView.builder(
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.business)),
                    title: Text(customer.name),
                    subtitle: Text(
                      '${customer.type == 'F' ? 'Física' : 'Jurídica'} - ${customer.document}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editCustomer(customer),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Confirmar exclusão'),
                                    content: Text(
                                      'Deseja realmente excluir o cliente ${customer.name}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteCustomer(customer);
                                        },
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CustomerFormScreen()),
          );
          _loadCustomers();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
