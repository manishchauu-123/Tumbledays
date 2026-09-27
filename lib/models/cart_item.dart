import 'catalog_garment.dart';

class CartItem {
  final CatalogGarment garment;
  int quantity;

  CartItem({
    required this.garment,
    this.quantity = 1,
  });

  double get totalPrice => garment.price * quantity;
}
