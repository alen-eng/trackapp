import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home_page_token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String url = "http://10.0.2.2:3000";

class Auth {
  static getUserFromLocal() async {
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    var user = shared_User.getString('user');
    // print(user);
    var returnval = user != null ? "OK" : "Error";

    return returnval;

    // Map<String,dynamic> userMap = jsonDecode(getuser!) as Map<String, dynamic>;
    // print("user: ${userMap['email']} ");
  }

  static saveuser(var response) async {
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    await shared_User.setString('user', jsonEncode(response));
  }

  static Future callSignUp({
    required String phone,
    required String password,
  }) async {
    try {
      // User  body= User(email: email,password: password ,name:name);

      //print(body.toJson());
      var response = await http.post(Uri.parse("$url/signup"),
          body: jsonEncode({
            "phone": phone,
            "password": password,
          }),
          headers: <String, String>{'content-type': "application/json"});

      print("status code  :${response.statusCode}");

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        // await signOut();
        await saveuser(res);
        return "OK";
      } else {
        if (response.statusCode == 400) {
          return jsonDecode(response.body)['msg'];
        } else {
          if (response.statusCode == 500 &&
              jsonDecode(response.body)['error'] ==
                  "User validation failed: phone: incorrect number format") {
            return "Invalid";
          }

          return "Error";
        }
      }
    } catch (e) {
      // print("an error occured : $e");
      int status = 400;
      return status;
    }
  }

  static Future callSignIn({
    required String phone,
    required String password,
  }) async {
    var body = {"phone": phone, "password": password};

    // print(body);
    http.Response response;
    try {
      response = await http.post(Uri.parse("$url/signin"),
          body: jsonEncode(body),
          headers: <String, String>{'content-type': "application/json"});

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        await saveuser(res);

        return "OK";
      } else {
        if (response.statusCode == 400) {
          return jsonDecode(response.body)['msg'];
        } else {
          return "Error";
        }
      }
    } catch (e) {
      return "Error";
    }
  }

  static Future callTokengen() async {
    http.Response response;
    try {
      SharedPreferences shared_User = await SharedPreferences.getInstance();
      var user = shared_User.getString('user');
      var response = await http.post(Uri.parse("$url/tokengen"),
          body: user,
          headers: <String, String>{'content-type': "application/json"});
    } catch (e) {
      return "Error";
    }
  }

  static Future callEnterTok({required String token}) async {
    //var data = {"token": token};
    http.Response response;
    try {
      SharedPreferences shared_User = await SharedPreferences.getInstance();
      var user = shared_User.getString('user');
      // var enc = jsonEncode({data, user});
      // print(enc);
      //var data = {token, user};
      var data = {"actual": token, "user": user};
      var js = jsonEncode(data);
      var response = await http.post(Uri.parse("$url/entertoken"),
          body: js,
          headers: <String, String>{'content-type': "application/json"});

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        //await saveuser(res);

        return "OK";
      } else {
        if (response.statusCode == 400) {
          return jsonDecode(response.body)['msg'];
        } else {
          return "Error";
        }
      }
    } catch (e) {
      return "Error";
    }
  }

  static Future callParentCheck({required String phone}) async {
    http.Response response;
    try {
      var datas = {"phone": phone};
      var sj = jsonEncode(datas);
      var response = await http.post(Uri.parse("$url/parentcheck"),
          body: sj,
          headers: <String, String>{'content-type': "application/json"});
      print(response.statusCode);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['msg'] == "PARENT") {
          return jsonDecode(response.body);
        } else if (res['msg'] == "CHILD") {
          return jsonDecode(response.body);
        } else {
          if (response.statusCode == 400) {
            return "NOT";
          } else {
            return "Error";
          }
        }
      }
    } catch (e) {
      return "Error";
    }
  }
}
