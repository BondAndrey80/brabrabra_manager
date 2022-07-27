import 'package:brabrabra_manager/models/product_1c.dart';
import 'package:brabrabra_manager/services/config.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:xml/xml.dart';
import 'dart:convert';

class ProductProvider {
  Future<List<Product>> getProductData(String articul) async {
    List<Product> productList = [];
    var headers = {
      'content-type': 'text/xml; charset=utf-8',
      'SOAPAction':
          'http://1c8.silenzagroup.com:81/ukr/ws/#OnlineStore:Sellers',
    };

    String body = ''' 
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
        <Body>
            <GetProductInfo xmlns="https://1c8.silenzagroup.com/ukr/ws/">
                <EAN>$articul</EAN>
            </GetProductInfo>
        </Body>
    </Envelope>
    ''';

    var client = BasicAuthClient(
        Configuration.loginOnlineStore, Configuration.passwordOnlineStore);

    try {
      var answer = await client.post(
        Uri.parse(Configuration.uriMobileApp),
        headers: headers,
        body: body,
      );

      XmlDocument xmlDocument = XmlDocument.parse(answer.body);
      var items = xmlDocument.findAllElements('m:return');

      String data = '';
      items.map((e) => data = e.text).toList();

      if (data.isEmpty != true) {
        var jsonData = jsonDecode(data);

        for (var element in jsonData['product_data']) {
          productList.add(Product(
              name: element['name'],
              articul: element['art'],
              comment: element['comment'])
            ..intitalProductFromData(element));
        }

        for (var element in jsonData['certificate_data']) {
          productList.add(Product(
              name: element['name'],
              articul: element['art'],
              comment: element['comment'])
            ..intitalProductFromData(element));
        }
      }
    } catch (e) {
      debugPrint("Exception - $e");
    }
    return productList;
  }
}
