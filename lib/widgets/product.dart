import 'package:brabrabra_manager/common/theme.dart';
import 'package:brabrabra_manager/models/product_1c.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: non_constant_identifier_names
Widget mainProductView(
    {required Product product, required BuildContext context}) {
  Widget result;

  if (product.productType == ProductType.certificate) {
    result = certificateWidget(product);
  } else {
    result = productWidget(product, context);
  }
  return result;
}

Widget productWidget(Product product, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: brabrabraBackgroundColor,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 5,
          offset: const Offset(0, 8), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        product.imgUrl.isEmpty
            ? InkWell(
                child: const Image(
                  image: AssetImage('assets/no_image_01.png'),
                  fit: BoxFit.contain,
                  width: 200,
                  height: 300,
                ),
                onTap: () => launchUrl(
                  Uri.parse('https://brabrabra.ua/ua/'),
                  mode: LaunchMode.externalApplication,
                ),
              )
            : InkWell(
                child: Image(
                  image: NetworkImage(product.imgUrl),
                  fit: BoxFit.contain,
                  width: 200,
                  height: 300,
                ),
                onTap: () => launchUrl(
                  Uri.parse(product.prdctUrl),
                  mode: LaunchMode.externalApplication,
                ),
              ),
        Row(
          children: const [
            Text(
              "Характеристики:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              rowWithSpacer("Артикул", product.articul),
              rowWithSpacer("Форма", product.form),
              rowWithSpacer("Фактура", product.texture),
              rowWithSpacer("Посадка", product.fit),
              rowWithSpacer("Конструкція", product.construct),
              rowWithSpacer("Тип чашки", product.braType),
            ],
          ),
        ),
        // const SizedBox(
        //   height: 12,
        // ),
        Row(
          children: [
            Text(
              "Склад:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Text(product.comment),
        ),
      ],
    ),
  );
}

Widget certificateWidget(Product product) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: certificateColor,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 5,
          offset: const Offset(0, 8), // changes position of shadow
        ),
      ],
    ),
    child: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("СЕРТИФІКАТ ${product.nominal.toInt()} грн",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[100],
                    fontSize: 24)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                rowWithSpacer2("EAN:", product.ean),
                rowWithSpacer2("Дійсний до:", product.term),
                rowWithSpacer2("Статус:", product.status),
                rowWithSpacer2("Активація:",
                    product.activated ? "Активован" : "НЕ аткивован"),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          )
        ],
      ),
    ),
  );
}

Widget rowWithSpacer(String title1, String title2) {
  return Row(
    children: [
      Text(title1),
      const Spacer(),
      Text(title2),
    ],
  );
}

Widget rowWithSpacer2(String title1, String title2) {
  TextStyle style = const TextStyle(fontWeight: FontWeight.bold);
  return Padding(
    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8, top: 8),
    child: Row(
      children: [
        Text(
          title1,
          style: style,
        ),
        const Spacer(),
        Text(
          title2,
          style: style,
        ),
      ],
    ),
  );
}
