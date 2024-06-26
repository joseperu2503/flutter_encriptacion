import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_encriptacion/encrypt_response.dart';

const keyCry = '3420Key2022App@@';

dynamic encryp(String text) {
  Uint8List salt = _generateRandomBytes(8);

  Uint8List salted = Uint8List(0);
  Uint8List dx = Uint8List(0);

  while (salted.length < 48) {
    dx = _md5(Uint8List.fromList([...dx, ...keyCry.codeUnits, ...salt]));
    salted = Uint8List.fromList([...salted, ...dx]);
  }

  Uint8List key = salted.sublist(0, 32);
  Uint8List iv = salted.sublist(32, 48);

  final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: IV(iv));

  return {
    "ct": encrypted.base64,
    "iv": hex.encode(iv),
    "s": hex.encode(salt),
  };
}

dynamic decryp(EncrypResponse encrypResponse) {
  Uint8List salt = Uint8List.fromList(hex.decode(encrypResponse.s));
  Uint8List iv = Uint8List.fromList(hex.decode(encrypResponse.iv));

  Uint8List concatedPassphrase =
      Uint8List.fromList([...keyCry.codeUnits, ...salt]);

  List<Uint8List> md5 = [];
  md5.add(_md5(concatedPassphrase));
  Uint8List result = md5[0];
  for (int i = 1; i < 3; i++) {
    md5.add(_md5(Uint8List.fromList([...md5[i - 1], ...concatedPassphrase])));
    result = Uint8List.fromList([...result, ...md5[i]]);
  }

  final key = Key(result.sublist(0, 32));

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = Encrypted.fromBase64(encrypResponse.ct);

  final decrypted = encrypter.decrypt(encrypted, iv: IV(iv));

  try {
    if (decrypted.contains('{') || decrypted.contains('[')) {
      final decryptedData = jsonDecode(decrypted);
      return decryptedData;
    }
    if (decrypted == 'true') {
      return true;
    }
    if (decrypted == 'false') {
      return false;
    }
    if (decrypted == 'null') {
      return null;
    }
    return decrypted;
  } catch (e) {
    return decrypted;
  }
}

Uint8List _generateRandomBytes(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (index) => random.nextInt(256));
  return Uint8List.fromList(values);
}

Uint8List _md5(Uint8List data) {
  return Uint8List.fromList(md5.convert(data).bytes);
}
