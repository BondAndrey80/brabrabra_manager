part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ArticulEditedState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<Product> listProducts;
  ProductLoadedState({required this.listProducts});
}

class BarCodeScanedState extends ProductState {
  final String barcode;
  BarCodeScanedState({required this.barcode});
}
