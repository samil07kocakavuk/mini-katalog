import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class CatalogController extends ChangeNotifier {
  CatalogController(this._apiService);

  final ApiService _apiService;

  List<Product> _products = const <Product>[];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProducts => _products.isNotEmpty;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _apiService.fetchProducts();
    } on ApiException catch (error) {
      _error = error.message;
    } catch (_) {
      _error = 'Ürünler yüklenirken beklenmeyen bir hata oluştu.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
