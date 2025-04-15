import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _statusController = TextEditingController();
  final _costController = TextEditingController();
  final _barcodeController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _isEditing = true;
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _unitController.text = widget.product!.unit;
      _stockController.text = widget.product!.stock.toString();
      _salePriceController.text = widget.product!.salePrice.toString();
      _statusController.text = widget.product!.status.toString();
      _costController.text = widget.product!.cost?.toString() ?? '';
      _barcodeController.text = widget.product!.barcode ?? '';
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final id =
          _isEditing
              ? widget.product!.id
              : await ProductController.generateId();

      final product = Product(
        id: id,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        unit: _unitController.text,
        stock: int.parse(_stockController.text),
        salePrice: double.parse(_salePriceController.text),
        status:
            _statusController.text.isEmpty
                ? 0
                : int.parse(_statusController.text),
        cost:
            _costController.text.isNotEmpty
                ? double.parse(_costController.text)
                : null,
        barcode:
            _barcodeController.text.isNotEmpty ? _barcodeController.text : null,
      );

      bool success;
      if (_isEditing) {
        success = await ProductController.updateProduct(product);
      } else {
        success = await ProductController.createProduct(product);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'Produto atualizado com sucesso!'
                    : 'Produto salvo com sucesso!',
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
                    ? 'Erro ao atualizar produto.'
                    : 'Erro ao salvar produto.',
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
        title: Text(_isEditing ? 'Editar Produto' : 'Cadastro de Produto'),
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
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value:
                    _unitController.text.isEmpty ? 'un' : _unitController.text,
                decoration: const InputDecoration(
                  labelText: 'Unidade*',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'un', child: Text('Unidade (un)')),
                  DropdownMenuItem(value: 'cx', child: Text('Caixa (cx)')),
                  DropdownMenuItem(value: 'kg', child: Text('Quilograma (kg)')),
                  DropdownMenuItem(value: 'lt', child: Text('Litro (lt)')),
                  DropdownMenuItem(value: 'ml', child: Text('Mililitro (ml)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _unitController.text = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a unidade do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em Estoque*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade em estoque';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(
                  labelText: 'Preço de Venda*',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço de venda';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um preço válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value:
                    _statusController.text.isEmpty
                        ? 0
                        : int.parse(_statusController.text),
                decoration: const InputDecoration(
                  labelText: 'Status*',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Ativo')),
                  DropdownMenuItem(value: 1, child: Text('Inativo')),
                ],
                onChanged: (value) {
                  setState(() {
                    _statusController.text = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione o status do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Custo',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Código de Barra',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
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
    _priceController.dispose();
    _unitController.dispose();
    _stockController.dispose();
    _salePriceController.dispose();
    _statusController.dispose();
    _costController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }
}
