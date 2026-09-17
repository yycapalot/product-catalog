import 'package:flutter/material.dart';
import '../../product_model.dart';
import '../../api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State variables
  List<Product> products = [];
  bool isLoading = false;
  bool isFetchingMore = false; // For pagination
  String? errorMessage;
  bool hasMore = true;

  int _skip = 0;
  final int _limit = 20;

  // 1. Initial Load
  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Show full-screen loading spinner

    try {
      final response = await _apiService.getProducts(limit: _limit, skip: 0);
      products = response.products;
      _skip = response.skip + _limit;
      hasMore = products.length < response.total;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // Hide spinner and show data/error
    }
  }

  // 2. Pagination (Load More)
  Future<void> loadMoreProducts() async {
    if (isFetchingMore || !hasMore) return;

    isFetchingMore = true;
    notifyListeners(); // Show small spinner at the bottom

    try {
      final response = await _apiService.getProducts(limit: _limit, skip: _skip);
      products.addAll(response.products); // Append new items to existing list
      _skip = response.skip + _limit;
      hasMore = (products.length < response.total);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isFetchingMore = false;
      notifyListeners();
    }
  }
}