import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_encriptacion/encrypt_response.dart';
import 'package:cryptography/cryptography.dart' as cryptography;

const keyCry = '123456';

dynamic encryp(String text) async {
  Uint8List salt = _generateRandomBytes(8);

  final pbkdf2 = cryptography.Pbkdf2(
    macAlgorithm: cryptography.Hmac.sha256(),
    iterations: 1000,
    bits: 256,
  );

  final newSecretKey = await pbkdf2.deriveKey(
    secretKey: cryptography.SecretKey(keyCry.codeUnits),
    nonce: salt,
  );

  final key2 = await newSecretKey.extractBytes();

  final key = Key(Uint8List.fromList(key2));
  final iv = IV.fromSecureRandom(16); // Generar un nuevo IV

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: iv);

  return {
    "ct": encrypted.base64,
    "iv": iv.base64,
    "s": base64.encode(salt),
  };
}

// String decryp(EncrypResponse encrypResponse) {
//   Uint8List salt = Uint8List.fromList(hex.decode(encrypResponse.s));
//   Uint8List iv = Uint8List.fromList(hex.decode(encrypResponse.iv));

//   Uint8List concatedPassphrase =
//       Uint8List.fromList([...keyCry.codeUnits, ...salt]);

//   List<Uint8List> md5 = [];
//   md5.add(_md5(concatedPassphrase));
//   Uint8List result = md5[0];
//   for (int i = 1; i < 3; i++) {
//     md5.add(_md5(Uint8List.fromList([...md5[i - 1], ...concatedPassphrase])));
//     result = Uint8List.fromList([...result, ...md5[i]]);
//   }

//   final key = Key(result.sublist(0, 32));

//   final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//   final encrypted = Encrypted.fromBase64(encrypResponse.ct);

//   final decrypted = encrypter.decrypt(encrypted, iv: IV(iv));
//   return decrypted;
// }

Future<String> decryp(EncrypResponse encrypResponse) async {
  Uint8List salt = base64.decode(encrypResponse.s);
  Uint8List iv = base64.decode(encrypResponse.iv);

  final pbkdf2 = cryptography.Pbkdf2(
    macAlgorithm: cryptography.Hmac.sha256(),
    iterations: 1000, // 20k iterations
    bits: 256, // 256 bits = 32 bytes output
  );

  final newSecretKey = await pbkdf2.deriveKey(
    secretKey: cryptography.SecretKey(keyCry.codeUnits),
    nonce: salt,
  );

  final key2 = await newSecretKey.extractBytes();

  final key = Key(Uint8List.fromList(key2));

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final encrypted = Encrypted.fromBase64(encrypResponse.ct);

  final decrypted = encrypter.decrypt(encrypted, iv: IV(iv));
  return decrypted;
}

Uint8List _generateRandomBytes(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (index) => random.nextInt(256));
  return Uint8List.fromList(values);
}

Uint8List _md5(Uint8List data) {
  return Uint8List.fromList(md5.convert(data).bytes);
}

String encryptAES(String plainText, String password) {
  String salt = _generateRandomBytes2(16);
  final iv = IV.fromLength(16);
  final key = Key.fromUtf8(salt);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

String decryptAES(String encryptedText, String password) {
  String salt = _generateRandomBytes2(16);
  final iv = IV.fromLength(16);
  final key = Key.fromUtf8(salt);
  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
  return decrypted;
}

// String createCryptoRandomString([int length = 32]) {
//   final values = List<int>.generate(length, (i) => pc.secureRandom.nextInt(256));
//   return base64Url.encode(values);
// }

String _generateRandomBytes2(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (index) => random.nextInt(256));
  return base64UrlEncode(values);
}

// class EncryptionHandler {
//   static const int keySize = 256;
//   static const int derivationIterations = 1000;

//   static String decrypt(String encryptedData, String passPhrase) {
//     final parts = encryptedData.split(":");
//     final salt = base64.decode(parts[0]);
//     final iv = IV.fromBase64(parts[1]);
//     final encryptedText = base64.decode(parts[2]);

//     final pbkdf2 = cryptography.Pbkdf2(
//       macAlgorithm: cryptography.Hmac.sha256(),
//       iterations: 10000, // 20k iterations
//       bits: 256, // 256 bits = 32 bytes output
//     );

//     final key = cryptography.Pbkdf2(
//       iterations: derivationIterations,
//       macAlgorithm: cryptography.Hmac.sha256(),
//       keySize: keySize ~/ 8,
//     ).process(utf8.encode(passPhrase), Uint8List.fromList(salt));

//     final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
//     final decrypted = encrypter.decrypt(Encrypted(encryptedText), iv: iv);

//     return decrypted;
//   }
// }
