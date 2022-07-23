//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/childpage.dart';
//import 'package:flutter_auth/Screens/Home/childpage.dart';
//import 'package:flutter_auth/Screens/Home/childpage.dart';
import 'package:flutter_auth/Screens/Home/parentpage.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/authentication/authFunctions.dart';
import 'package:flutter_auth/providers/authListener.dart';
import 'package:provider/provider.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../Home/home_page_token.dart';
import '../../Signup/components/sign_up_top_image.dart';
import '../../Signup/components/signup_form.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  var phoneValid;
  var passValid;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final logFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  onloginClick() async {
    var phone = phoneController.text.trim();
    var pass = passwordController.text.trim();

    passValid = null;
    phoneValid = null;

    if (pass.isNotEmpty && phone.isNotEmpty) {
      //loading(context);

      var response = await Auth.callSignIn(phone: phone, password: pass);
      var pc = await Auth.callParentCheck(phone: phone);
      Navigator.pop(context);
      print("resposne $response");
      print(pc);
      if (response == "OK" && pc['msg'] == "PARENT") {
        Provider.of<AuthListen>(this.context, listen: false).signInUser();
        //Navigator.pop(context);
        var phone = pc['child'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Parent();
            },
          ),
        );
      } else if (response == "OK" && pc['msg'] == "CHILD") {
        Provider.of<AuthListen>(this.context, listen: false).signInUser();
        var phone = pc['parent'];
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Child();
            },
          ),
        );
      } else if (response == "OK" && pc['msg'] == "NOT") {
        Provider.of<AuthListen>(this.context, listen: false).signInUser();
        //Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Home();
            },
          ),
        );
      } else {
        if (response == "Email Already Exists") {
          phoneValid = response;
        } else if (response == "Invalid") {
          phoneValid = "Invalid  Format";
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error in Logging Up")));
        }
      }
    } else {
      if (phone.isEmpty) {
        phoneValid = "Phone Cannot be Empty";
      }
      if (pass.isEmpty) {
        passValid = "password cannot be empty";
      }
    }
    // if (formState.)
    //logFormKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final FormState? formState = logFormKey.currentState;
    formState?.save();
    return Form(
      key: logFormKey,
      child: Column(children: [
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          cursorColor: kPrimaryColor,
          onSaved: (phone) {},
          validator: (val) => phoneValid,
          decoration: InputDecoration(
            hintText: "Mobile number",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            onSaved: (password) {},
            validator: (val) => passValid,
            decoration: InputDecoration(
              hintText: "Your password",
              prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock)),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding / 2),
        ElevatedButton(
          onPressed: () {
            formState?.save();
            onloginClick();
          },
          child: Text("Login".toUpperCase()),
        ),
        const SizedBox(height: defaultPadding),
        AlreadyHaveAnAccountCheck(
          login: true,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          },
        )
      ]),
    );
  }
}
