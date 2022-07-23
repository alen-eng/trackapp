import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/tokenEnter.dart';
import 'package:flutter_auth/Screens/Home/tokenScreen.dart';
import 'package:flutter_auth/authentication/authFunctions.dart';
import 'package:flutter_auth/providers/authListener.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';

class ParentChildBtn extends StatelessWidget {
  const ParentChildBtn({
    Key? key,
  }) : super(key: key);
  token_gen() async {
    var response = await Auth.callTokengen();
  }

  // enter_tok() async {
  //   var response = await Auth.callEnterTok();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "parent_btn",
          child: ElevatedButton(
            onPressed: () {
              token_gen();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Text("OK");
                  },
                ),
              );
            },
            child: Text(
              "Generate Token",
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            //enter_tok();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TokenScreen();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              primary: kPrimaryLightColor, elevation: 0),
          child: Text(
            "Enter the Token",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
