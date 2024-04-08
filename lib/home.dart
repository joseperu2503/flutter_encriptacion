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

    final formEncryp = encryp(jsonEncode(form));
    print(formEncryp);

    //desencriptar
    final encrypResponse = EncrypResponse.fromJson(formEncryp);
    final respuestaDesencriptada = decryp(encrypResponse);
    print(respuestaDesencriptada);
  }

  desencriptar() {
    final encrypResponse = EncrypResponse.fromJson({
      "ct":
          "rZGqr3o2bCEJKyIiglkp6eHV8cPj7cbM8fjqAu9m/29o00YA3ovYfWrRRHcAz9nOM9sYyLP9rUHA/28R2RH3jJ4MGXg7G7iGLkqdy9nlTeTYJRoUhndUubBCjoboavvRzgT3qQ26TRqJMKKlAI49SDRVRwWp3uyjlWO/027NPLmbYTyYzX3XIOT4c+IiVV7Ey81TGRj2PzDcuk4IEF6I/w8RCWA87aAzvLsvzRdac1/l0XL1TBW//20Qkr8rqkGEsliJfg5QaW5VfuED+oNKkHiGMtZb8oqwufSauO1VM7tL9NJRR/QwnlyHZji6HqKsZbHWetNZvMowL28uSQvmetbtBRS9R9jB5Z/PpULlz78JAw5awm075nUCuUtBYkFNa8LmROdF5ur8TjnrkyjsMTz9DgANIVJSHcgXpUXH2VFivQW/aA7WMbFQXGP8sDNhL3hQG6zgmb4BpjFG4uk5W4ZaCQI78PpSCscW+KG780Z2M6HGItfcU4Sru5CWJ7Ie4IMV8eJNNHw3najqGIexerKtDYaaBQd9OiFUneEiWDfPEB4pxoO/Oi/tPiIve+NvMgAi4hiPcGrEgmzKsnWoFNRsz+Cw5BgHqqpICW1NQ5F6jnMZWEW5/010XeG6zTXoOd20/I0XKt0lzqgFGWfWTs7gbBJZjGmLRyxqGzv++EKmfJzFQJxAkmfvoyEApLDFyHdTvsXFs6DZNx9QKGkM50mtu4LIgeQ57AGxyY13dOa+BjLK6vByLe4lMsEcNLN1ImxioAgy0y7YQwf9tCCXVMO301H8g1AwpRgE8TNnxGz66TptpkpQFrWdan/kJjSf8Cog3YhiYJkFD9KuS244GdOlG5A4mjM+RUVYB8cypRn/hHlbCEGtikPSc9amp/muxE1Y/13ND2JnIvNUn0rpkHDvNu0EqN3Vdy2QHyWZdsIt12wjG9EG8OaAczXDrKIl8LtV2RhWhrL8voLvbB19Gw==",
      "iv": "efb3b240f380de537904233bee2c1a41",
      "s": "7023a828919b28b0"
    });

    final respuestaDesencriptada = decryp(encrypResponse);
    print(jsonDecode(respuestaDesencriptada));
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
