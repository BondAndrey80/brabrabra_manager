// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import 'package:brabrabra_manager/models/product_1c.dart';
import 'package:brabrabra_manager/services/product_repository.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  String articul = '';
  final ProductRepository _productRepository = ProductRepository();

  ProductBloc() : super(ProductInitial()) {
    on<ArticulEditEvent>((event, emit) {
      articul = event.articul;
      emit(ArticulEditedState());
    });

    on<SearchButtonTuppedEvent>((event, emit) async {
      emit(ProductLoadingState());
      List<Product> listProducts =
          await _productRepository.getProductData(articul);
      emit(ProductLoadedState(listProducts: listProducts));
    });

    on<BarCodeButtonTuppedEvent>(
      (event, emit) async {
        String barcodeScanRes;
        try {
          barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', 'Cancel', true, ScanMode.BARCODE);
        } on PlatformException {
          barcodeScanRes = 'Failed to get platform version.';
        }
        emit(BarCodeScanedState(barcode: barcodeScanRes));
      },
    );
  }
}
