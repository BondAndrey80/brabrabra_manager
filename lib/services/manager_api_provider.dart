import 'dart:convert';
import 'package:brabrabra_manager/models/manager.dart';
import 'package:brabrabra_manager/services/config.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:xml/xml.dart';

class ManagerProvider {
  Future<Manager> getManagerByKey(String key) async {
    var result = Manager();
    result.isFired = true;
    result.cassierKey = key;

    var headers = {
      'content-type': 'text/xml; charset=utf-8',
      'SOAPAction':
          'http://1c8.silenzagroup.com:81/ukr/ws/#OnlineStore:Sellers',
    };

    String body = ''' 
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
        <Body>
            <Sellers xmlns="http://1c8.silenzagroup.com:81/ukr/ws/">
                <AllSallers>false</AllSallers>
            </Sellers>
        </Body>
    </Envelope>
    ''';

    var client = BasicAuthClient(
        Configuration.loginOnlineStore, Configuration.passwordOnlineStore);
    try {
      var answer = await client.post(
        Uri.parse(Configuration.uriOnlineStore),
        headers: headers,
        body: body,
      );

      XmlDocument xmlDocument = XmlDocument.parse(answer.body);
      var items = xmlDocument.findAllElements('m:return');

      String data = '';
      items.map((e) => data = e.text).toList();

      if (data.isEmpty != true) {
        var jsonData = jsonDecode(data);

        for (var e in jsonData['data']) {
          if (e['Key'] == key) {
            result.ref = e['Ref'];
            result.name = e['Name'];
            result.isFired = false;
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('Exception - $e');
    }
    return result;
  }
}
