import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _items = List.generate(12, (index) {
    const prices = [
      1800.0, 25000.0, 3000.0, 2000.0,
      1200.0, 4500.0, 800.0, 15000.0,
      6500.0, 9999.0, 3450.0, 12000.0
    ];
    return Product(
      id: 'p${index + 1}',
      title: 'Premium Product ${index + 1}',
      price: prices[index],
      imageUrl: 'assets/images/Background.png',
    );
  });

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isSaved).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void toggleFavoriteStatus(String id) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _items[productIndex].isSaved = !_items[productIndex].isSaved;
      notifyListeners();
    }
  }
}
