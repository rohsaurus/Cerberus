import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUp {
  late String _email;
  late String _password;
  int _statusCode = 200;
  late String AUTH_KEY;
// create  a constructor that takes in the email and password
  SignUp(email, password) {
    AUTH_KEY = dotenv.env['AUTH_KEY'] ?? 'NoValue';
    _email = email;
    _password = password;
  }

  void signup() async {
    // check to make sure that AUTH_KEY is not null
    if (AUTH_KEY == 'NoValue') {
      print('AUTH_KEY is null');
      return;
    }
    var _headers = {
      'authorization': AUTH_KEY,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://mongo-realm-worker.duckman848.workers.dev/api/userid'));
    request.body = json.encode({
      "_id": _email,
      "password": _password,
    });
    request.headers.addAll(_headers);

    http.StreamedResponse response = await request.send();
    _statusCode = response.statusCode;
  }

  int get statusCode => _statusCode;

// check if the user is already in the database
  Future<bool> checkUser() async {
    // check to make sure that AUTH_KEY is not null
    if (AUTH_KEY == 'NoValue') {
      print('AUTH_KEY is null');
      return false;
    }
    var _headers = {
      'authorization':
          AUTH_KEY,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://mongo-realm-worker.duckman848.workers.dev/api/userid'));
    request.body = json.encode("$_email");
    request.headers.addAll(_headers);

    http.StreamedResponse response = await request.send();
    bool toBeReturned = false;
    if (response.statusCode == 200) {
      var temp = await response.stream.bytesToString();
      if (temp == "null") {
        toBeReturned = false;
      } else {
        toBeReturned = true;
      }
    } else {
      print(response.reasonPhrase);
    }
    return toBeReturned;
  }

  Future<Map<String, dynamic>> getUser() async {
    // check to make sure that AUTH_KEY is not null
    if (AUTH_KEY == 'NoValue') {
      print('AUTH_KEY is null');
      return {'error': 'null'};
    }
    var headers = {
      'authorization':
          AUTH_KEY,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://mongo-realm-worker.duckman848.workers.dev/api/userid'));
    request.body = json.encode("$_email");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    bool toBeReturned = false;
    var temp = await response.stream.bytesToString();
    // serialize temp into a json object
    var jsonObject = json.decode(temp);
    if (jsonObject == null) {
      return {'error': 'null'};
    }
    if (response.statusCode == 200) {
      return jsonObject;
    } else {
      return {'error': response.reasonPhrase};
    }
  }
}
