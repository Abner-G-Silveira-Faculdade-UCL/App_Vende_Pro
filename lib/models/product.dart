class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String unit;
  final double salePrice;
  final int status;
  final double? cost;
  final String? barcode;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.unit,
    required this.salePrice,
    required this.status,
    this.cost,
    this.barcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'unit': unit,
      'salePrice': salePrice,
      'status': status,
      'cost': cost,
      'barcode': barcode,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int,
      unit: json['unit'] as String,
      salePrice: json['salePrice'] as double,
      status: json['status'] as int,
      cost: json['cost'] as double?,
      barcode: json['barcode'] as String?,
    );
  }
}
