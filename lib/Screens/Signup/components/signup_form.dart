import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/login_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../authentication/authFunctions.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../providers/authListener.dart';
import '../../Login/login_screen.dart';
import 'package:load/load.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _MyLoginState();
}

class _MyLoginState extends State<SignUpForm> {
  var phoneValid;
  var passValid;
  onSignupClick() async {
    var phone = phonecontroller.text.trim();
    var password = passwordcontroller.text.trim();

    phoneValid = null;
    passValid = null;

    if (phone.isNotEmpty && password.isNotEmpty) {
      LoadingProvider(
        themeData: LoadingThemeData(),
        child: MaterialApp(),
      );

      var response = await Auth.callSignUp(phone: phone, password: password);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (response == "OK") {
        Provider.of<AuthListen>(this.context, listen: false).signInUser();
      } else {
        if (response == "Invalid Phone") {
          phoneValid = "Invalid Phone";
          passValid = null;
        } else if (response == "Incorrect password") {
          passValid = response;
          phoneValid = null;
        } else {
          ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(content: Text("Error in Signing In")));
        }
      }
    } else {
      if (phone.isEmpty) {
        phoneValid = "Email cannot be empty";
      }

      if (password.isEmpty) {
        passValid = "Password cannot be empty";
      }
    }
    formKey.currentState!.validate();
  }

  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: phonecontroller,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (phone) {},
            validator: (val) => phoneValid,
            decoration: InputDecoration(
              hintText: "Mobile number",
              prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordcontroller,
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
            onPressed: onSignupClick,
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
