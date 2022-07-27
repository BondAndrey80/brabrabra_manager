import 'package:brabrabra_manager/services/product_api_provider.dart';
import '../models/product_1c.dart';

class ProductRepository {
  final _productProvider = ProductProvider();
  Future<List<Product>> getProductData(String articul) {
    return _productProvider.getProductData(articul);
  }
}
