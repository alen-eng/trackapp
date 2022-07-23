import 'package:flutter/material.dart';
import 'package:flutter_auth/providers/authListener.dart';
import 'package:flutter_auth/rangeapp.dart';
import 'package:provider/provider.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthListen()),
    ], child: RangeApp());
  }
}
