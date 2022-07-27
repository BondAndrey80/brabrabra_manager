part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ArticulEditEvent extends ProductEvent {
  final String articul;
  ArticulEditEvent({required this.articul});
}

class SearchButtonTuppedEvent extends ProductEvent {}

class BarCodeButtonTuppedEvent extends ProductEvent {}
