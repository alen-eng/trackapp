import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/authentication/authFunctions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_auth/providers/authListener.dart';
import 'package:provider/provider.dart';

class RangeApp extends StatefulWidget {
  @override
  State<RangeApp> createState() => _MyAppState();
}

class _MyAppState extends State<RangeApp> {
  //const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Auth',
//       theme: ThemeData(
//           primaryColor: kPrimaryColor,
//           scaffoldBackgroundColor: Colors.white,
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               primary: kPrimaryColor,
//               shape: const StadiumBorder(),
//               maximumSize: const Size(double.infinity, 56),
//               minimumSize: const Size(double.infinity, 56),
//             ),
//           ),
//           inputDecorationTheme: const InputDecorationTheme(
//             filled: true,
//             fillColor: kPrimaryLightColor,
//             iconColor: kPrimaryColor,
//             prefixIconColor: kPrimaryColor,
//             contentPadding: EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               borderSide: BorderSide.none,
//             ),
//           )),
//       home: const WelcomeScreen(),
//     );
//   }
// }

  @override
  void initState() {
    findUser();
    super.initState();
  }

  findUser() async {
    String res = await Auth.getUserFromLocal();

    // print(res);

    if (res == "OK") {
      Provider.of<AuthListen>(context, listen: false).signInUser();
    } else {
      Provider.of<AuthListen>(context, listen: false).signOutUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Provider.of<AuthListen>(context, listen: true).isSignedIn
            ? WelcomeScreen()
            : SignUpScreen(),
      );
    });
  }
}
