import 'dart:io';


import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
class EncryptTool {
  ///  加密
  static encryption(content) {
    // final key = Key.fromUtf8(BLConfig.AES_KEY);
    // final iv = IV.fromLength(16);
    //
    // final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    //
    // final encrypted = encrypter.encrypt(content, iv: iv);
    //
    // print("encrypted:");
    //
    // print(encrypted.base64);
    //
    // return encrypted.base64;

    var encoded1 = base64.encode(utf8.encode(content));
    print('Encoded 1: $encoded1');

    return encoded1;
  }
}
