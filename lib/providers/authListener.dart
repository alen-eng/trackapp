import 'package:flutter/material.dart';

class AuthListen with ChangeNotifier {
  bool isSignedIn = false;
  bool isParent = false;
  bool isChild = false;
  signInUser() {
    isSignedIn = true;
    notifyListeners();
  }

  parentUser() {
    isParent = true;
    notifyListeners();
  }

  childUser() {
    isChild = true;
    notifyListeners();
  }

  signOutUser() {
    isSignedIn = false;
    //Auth.signOut;
    notifyListeners();
  }
}
