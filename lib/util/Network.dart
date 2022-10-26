import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Network {
  // final String _url = 'http://192.168.1.4/PrincipalsClubAdminPannel/api';
  // final String _webURL = 'http://192.168.1.4/PrincipalsClubAdminPannel';

  final String _url = 'http://10.0.2.2/dietplan/api';
  final String _webURL = 'http://10.0.2.2/dietplan';
  final String _bucketURl ='https://theprincipalsclub.ams3.digitaloceanspaces.com';

  // final String _url = 'https://admin.theprincipalsclub.com/api';
  // final String _webURL = 'https://admin.theprincipalsclub.com';
  var Signature;
  var digest;
  var dateToday;


  var token;
  getBucketURL() {
    return _bucketURl;
  }
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // token = jsonDecode(localStorage.getString('token'))['token'];
  }
  getapiURL() {
    return _url;
  }
  postAPIData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    Uri url = Uri.parse(fullUrl);
    print(url.toString());
    return await http.post(url, body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    print(fullUrl);
    Uri url = Uri.parse(fullUrl);
    return await http.get(url, headers: _setHeaders());
  }

  getDataPrint(apiUrl) async {
    var fullUrl = _webURL + apiUrl;
    print(fullUrl);
    Uri url = Uri.parse(fullUrl);
    return await http.get(url, headers: _setHeaders());
  }

  getDataAPI(apiUrl) async {
    var fullUrl = _url + apiUrl;
    Uri url = Uri.parse(fullUrl);
    return await http.post(url, headers: _setHeaders());
  }

  getURL() {
    return _webURL;
  }



  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'Connection': 'keep-alive',
  };
}
