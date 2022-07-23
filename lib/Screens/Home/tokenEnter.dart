//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home_page_token.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/authentication/authFunctions.dart';
import 'package:flutter_auth/providers/authListener.dart';
import 'package:provider/provider.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import 'package:flutter_auth/Screens/Welcome/components/welcome_image.dart';
// import '../../Home/home_page_token.dart';
// import '../../Signup/components/sign_up_top_image.dart';
// import '../../Signup/components/signup_form.dart';
// import '../../Signup/signup_screen.dart';

class TokenEnterForm extends StatefulWidget {
  @override
  State<TokenEnterForm> createState() => _TokenState();
}

class _TokenState extends State<TokenEnterForm> {
  TextEditingController tokenController = TextEditingController();
  final tokenFormKey = GlobalKey<FormState>();
  var tokenValid;
  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  ontokenClick() async {
    var token = tokenController.text.trim();

    tokenValid = null;

    if (token.isNotEmpty == true) {
      //loading(context);

      var response = await Auth.callEnterTok(token: token);

      Navigator.pop(context);
      print("resposne $response");

      if (response == "OK") {
        Provider.of<AuthListen>(this.context, listen: false).childUser();
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
        if (response == "Invalid Token") {
          tokenValid = response;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Invaid Token")));
        }
      }
    } else {
      if (token.isEmpty) {
        tokenValid = "Token Cannot be Empty";
      }
    }
    // if (formState.)
    tokenFormKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final FormState? formState = tokenFormKey.currentState;
    formState?.save();
    return Form(
      key: tokenFormKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //const WelcomeImage(),
        TextFormField(
          controller: tokenController,
          keyboardType: TextInputType.visiblePassword,
          //scrollPhysics: const NeverScrollableScrollPhysics(),
          textInputAction: TextInputAction.next,
          cursorColor: kPrimaryColor,
          onSaved: (token) {},
          validator: (val) => tokenValid,
          decoration: InputDecoration(
            hintText: "Enter Your Token",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Icon(Icons.token),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        ),
        // const SizedBox(height: defaultPadding / 2),
        ElevatedButton(
          onPressed: () {
            formState?.save();
            ontokenClick();
          },
          child: Text("Submit".toUpperCase()),
        ),
        //  const SizedBox(height: defaultPadding),
      ]),
    );
  }
}
