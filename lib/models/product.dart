class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    this.specs = const <String, String>{},
  });

  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  double get priceValue {
    final normalized = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'];
    final specs = <String, String>{};
    if (rawSpecs is Map<dynamic, dynamic>) {
      for (final entry in rawSpecs.entries) {
        specs[entry.key.toString()] = entry.value?.toString() ?? '';
      }
    }
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'USD',
      image: json['image']?.toString() ?? '',
      specs: specs,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'tagline': tagline,
        'description': description,
        'price': price,
        'currency': currency,
        'image': image,
        'specs': specs,
      };
}
