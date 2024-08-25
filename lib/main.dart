import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/Screen/SplashScreen.dart';
import 'package:we_spilit/ThemeProvider.dart';
import 'package:we_spilit/firebase_options.dart';
import 'package:we_spilit/provider/auth_provider.dart';
import 'package:we_spilit/provider/friends_provider.dart';
import 'package:we_spilit/provider/search_provider.dart';
import 'package:we_spilit/provider/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AuthenticateProvider()),
      ChangeNotifierProvider(create: (context) => FriendsProvider()),
      ChangeNotifierProvider(create: (context) => SearchProvider()),
    ],
    child: const WeSplitApp(),
  ));
}

class WeSplitApp extends StatelessWidget {
  const WeSplitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Set SplashScreen as the initial route
    );
  }
}
