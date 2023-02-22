import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUp {
  String _email;
  String _password;
  int _statusCode = 200;
// create  a constructor that takes in the email and password
  SignUp(this._email, this._password);

  void signup() async {
    var _headers = {
      'authorization':
          String.fromEnvironment("auth"),
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
    var _headers = {
      'authorization':
          'dzk1ih9kMnRPDE1SXgiBlKvBB8IEMvYofZNga9E4rqh1xk4U5fNvgbmo1OhQXvuT',
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
    var headers = {
      'authorization':
          'dzk1ih9kMnRPDE1SXgiBlKvBB8IEMvYofZNga9E4rqh1xk4U5fNvgbmo1OhQXvuT',
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
    if (response.statusCode == 200) {
      return jsonObject;
    } else {
      return {'error': response.reasonPhrase};
    }
  }
}
