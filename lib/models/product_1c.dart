enum ProductType { bra, underpants, certificate, none }

class Product {
  ProductType productType = ProductType.none;
  String name;
  String articul;
  String comment;
  Product({required this.name, required this.articul, required this.comment});

  //data for bra & underpants
  String form = '';
  String texture = '';
  String fit = '';
  String construct = '';
  String braType = '';
  String imgUrl = '';
  String prdctUrl = '';

  //data for certificate
  String term = '';
  String status = '';
  double nominal = 0;
  bool activated = false;
  String ean = '';

  void intitalProductFromData(Map<String, dynamic> data) {
    switch (data['category_cod']) {
      case 'certificate':
        productType = ProductType.certificate;
        break;
      case 'bra':
        productType = ProductType.bra;
        break;
      case 'underpants':
        productType = ProductType.underpants;
        break;
      default:
        productType = ProductType.none;
    }

    if (productType == ProductType.certificate) {
      //data for certificate
      term = data['term'];
      status = data['status'];
      nominal = data['nominal'] * 1.0;
      activated = data['activated'];
      ean = data['EAN'];
    } else {
      //data for bra & underpants
      form = data['form'];
      texture = data['texture'];
      fit = data['fit'];
      construct = data['construct'];
      braType = data['bra_type'];
      imgUrl = data['img_url'];
      prdctUrl = data['uri'];
    }
  }
}
