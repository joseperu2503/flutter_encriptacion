import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_encriptacion/enc_dec.dart';
import 'package:flutter_encriptacion/encrypt_response.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  encriptar() async {
    Map<String, dynamic> form = {
      "tipoDocumento": "DNI",
      "nroDocumento": "07582919",
      "password": "1234Nimda",
    };

    final formEncryp = await encryp(jsonEncode(form));
    print(formEncryp);

    //desencriptar
    final encrypResponse = EncrypResponse.fromJson(formEncryp);
    final respuestaDesencriptada = await decryp(encrypResponse);
    print(respuestaDesencriptada);
  }

  desencriptar() async {
    final encrypResponse = EncrypResponse.fromJson({
      "ct":
          "8dJc8rV0VjVsjVGzR9zhz7i4stQy1VqgYC+GjvDJYFcHK50EEMIKUhv2NivWFn/TCp8/oS0uiqwba6f/dspqqN/x6/tr46SJVN7YlxtTiK1y1NL7MBeU/7bpYrepilmU",
      "iv": "cm7MtTON2o5/cdylqvHl5g==",
      "s": "t2pTtDgrRC/AOQ44JBtxoGq/g6ZnMmOdf7jiaBUqHHg="
    });

    final respuestaDesencriptada = await decryp(encrypResponse);
    print(respuestaDesencriptada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () {
                encriptar();
              },
              style: const ButtonStyle(),
              child: const Text('Encriptar'),
            ),
            FilledButton(
              onPressed: () {
                desencriptar();
              },
              style: const ButtonStyle(),
              child: const Text('Desencriptar'),
            ),
          ],
        ),
      ),
    );
  }
}
