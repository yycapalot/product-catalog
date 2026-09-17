import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Attach the listener as soon as the screen loads
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Prevent memory leaks when leaving the screen
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // If we are near the bottom of the list, fetch more data
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Use context.read instead of context.watch inside functions
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<ProductProvider>().onSearchChanged(query);
              },
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {

                // Restored your missing loading state!
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null && provider.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.fetchProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.products.length + (provider.isFetchingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.products.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return ProductCard(product: provider.products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}