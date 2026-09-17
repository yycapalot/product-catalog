import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/product_model.dart';
import '../../data/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State variables
  List<Product> products = [];
  bool isLoading = false;
  bool isFetchingMore = false; // For pagination
  String? errorMessage;
  bool hasMore = true;
  Timer? _debounce;
  bool isSearching = false; // Tracks if we are in search mode

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

  // 3. Debounced Search Input
  void onSearchChanged(String query){
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        isSearching = false;
        fetchProducts(); // Reload normal list if search is cleared
      }
      else {
        isSearching = true;
        _performSearch(query);
      }
    });
  }

  // 4. Search API Call
  Future<void> _performSearch(String query) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.searchProducts(query);
      products = response.products;
      hasMore = false; // Disable infinite scroll during active search
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}