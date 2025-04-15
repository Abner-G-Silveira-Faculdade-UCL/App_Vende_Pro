import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/customer_controller.dart';
import '../models/customer.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _isEditing = true;
      _nameController.text = widget.customer!.name;
      _typeController.text = widget.customer!.type;
      _documentController.text = widget.customer!.document;
      _emailController.text = widget.customer!.email;
      _phoneController.text = widget.customer!.phone;
      _zipCodeController.text = widget.customer!.zipCode;
      _addressController.text = widget.customer!.address;
      _neighborhoodController.text = widget.customer!.neighborhood;
      _cityController.text = widget.customer!.city;
      _stateController.text = widget.customer!.state;
    }
  }

  Future<void> _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      final id =
          _isEditing
              ? widget.customer!.id
              : await CustomerController.generateId();

      final customer = Customer(
        id: id,
        name: _nameController.text,
        type: _typeController.text,
        document: _documentController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        zipCode: _zipCodeController.text,
        address: _addressController.text,
        neighborhood: _neighborhoodController.text,
        city: _cityController.text,
        state: _stateController.text,
      );

      bool success;
      if (_isEditing) {
        success = await CustomerController.updateCustomer(customer);
      } else {
        success = await CustomerController.createCustomer(customer);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'Cliente atualizado com sucesso!'
                    : 'Cliente salvo com sucesso!',
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'Erro ao atualizar cliente.'
                    : 'Erro ao salvar cliente.',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cliente' : 'Cadastro de Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value:
                    _typeController.text.isEmpty ? 'F' : _typeController.text,
                decoration: const InputDecoration(
                  labelText: 'Tipo*',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'F', child: Text('Física')),
                  DropdownMenuItem(value: 'J', child: Text('Jurídica')),
                ],
                onChanged: (value) {
                  setState(() {
                    _typeController.text = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o tipo de cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentController,
                decoration: const InputDecoration(
                  labelText: 'CPF/CNPJ*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF/CNPJ do cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _neighborhoodController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'UF',
                  border: OutlineInputBorder(),
                ),
                maxLength: 2,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCustomer,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(_isEditing ? 'Atualizar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _zipCodeController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }
}
