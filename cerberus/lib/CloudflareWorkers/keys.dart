import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Keys {
  @required
  String _email;
  String _pubKey = "";
  String _privKey = "";
  var headers = {
    'authorization':
        String.fromEnvironment("auth"),
    'Content-Type': 'application/json'
  };
  // make a constructor that takes in those three values
  Keys(this._email, this._pubKey, this._privKey);
  Keys.emailOnly(this._email);

  void postKeys() async {
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://mongo-keypair-realm-worker.duckman848.workers.dev/api/keypairs'));
    request.body = json.encode({
      "_id": _email,
      "public": _pubKey,
      "private": _privKey,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> getKeys(int pubOrPriv) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://mongo-keypair-realm-worker.duckman848.workers.dev/api/keypairs'));
    request.body = json.encode("$_email");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
// read response into a JSON
    var responseJson = json.decode(await response.stream.bytesToString());
    if (pubOrPriv == 0) {
      // return the public key from the response
      return responseJson['public'];
    } else {
      // return the private key from the response
      return responseJson['private'];
    }
  }
}
