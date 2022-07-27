import 'package:brabrabra_manager/bloc/product_bloc.dart';
import 'package:brabrabra_manager/common/theme.dart';
import 'package:brabrabra_manager/models/manager.dart';
import 'package:brabrabra_manager/models/product_1c.dart';
import 'package:brabrabra_manager/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CatalogView extends StatelessWidget {
  Manager manager;
  ProductBloc productBloc = ProductBloc();
  CatalogView({Key? key, required this.manager}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //manager = context.manager;
    return BlocProvider(
      create: ((context) => productBloc),
      child: Scaffold(
        backgroundColor: brabrabraBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: ResultBody(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
          ),
          onPressed: () {
            productBloc.add(BarCodeButtonTuppedEvent());
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ResultBody extends StatelessWidget {
  List<Product> productList = [];
  bool _showProgressBar = false;
  final _artController = TextEditingController();
  ResultBody({Key? key}) : super(key: key);

  void dispose() {
    _artController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: ((context, state) {
        if (state is ProductLoadedState) {
          productList = state.listProducts;

          if (productList.isEmpty) {
            final snackBar = SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              content: const Text(
                'За запитом нічого не знайдено!',
                textAlign: TextAlign.center,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
        if (state is ProductLoadingState) {
          productList = [];
        }
        if (state is BarCodeScanedState) {
          _artController.text = state.barcode;
          if (state.barcode.isNotEmpty) {
            BlocProvider.of<ProductBloc>(context)
                .add(ArticulEditEvent(articul: state.barcode));
            BlocProvider.of<ProductBloc>(context)
                .add(SearchButtonTuppedEvent());
          }
        }
        _showProgressBar = (state is ProductLoadingState);
      }),
      buildWhen: (previusState, currentState) {
        return previusState != currentState;
      },
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              title: const Text('brabrabra'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.white,
                          //initialValue: _barcode,
                          controller: _artController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String? value) {
                            BlocProvider.of<ProductBloc>(context).add(
                                ArticulEditEvent(articul: value.toString()));
                          },
                          onFieldSubmitted: (String value) {
                            BlocProvider.of<ProductBloc>(context)
                                .add(SearchButtonTuppedEvent());
                          },
                          decoration: const InputDecoration(
                            hintText: 'Артикул, EAN',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            helperText: 'Для пошуку введіть артикул або EAN',
                            helperStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          BlocProvider.of<ProductBloc>(context)
                              .add(SearchButtonTuppedEvent());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _showProgressBar
                ? const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext cont, int index) {
                        return mainProductView(
                            product: productList.elementAt(index),
                            context: context);
                      },
                      childCount: productList.length,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
