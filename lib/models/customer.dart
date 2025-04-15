class Customer {
  final int id;
  final String name;
  final String type;
  final String document;
  final String email;
  final String phone;
  final String address;
  final String zipCode;
  final String neighborhood;
  final String city;
  final String state;

  Customer({
    required this.id,
    required this.name,
    required this.type,
    required this.document,
    required this.email,
    required this.phone,
    required this.address,
    required this.zipCode,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'document': document,
      'email': email,
      'phone': phone,
      'address': address,
      'zipCode': zipCode,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      document: json['document'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      zipCode: json['zipCode'] as String,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
    );
  }
}
