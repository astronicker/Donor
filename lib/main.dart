import 'package:donor/Pages/home.dart';
import 'package:donor/Pages/landing.dart';
import 'package:donor/Pages/login.dart';
import 'package:donor/Pages/profile.dart';
import 'package:donor/Pages/register.dart';
import 'package:donor/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: AuthGate(),
      routes: {
        'Landing': (context) => LandingPage(),
        'Login': (context) => LoginPage(),
        'Register': (context) => RegisterPage(),
        'Home': (context) => HomePage(),
        'Profile': (context) => ProfilePage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return HomePage();
    } else {
      return LandingPage();
    }
  }
}
