import 'package:donor/Pages/login.dart';
import 'package:donor/Theme/color_extension.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              "Hello...",
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Welcome to Donor",
              style: TextStyle(
                fontSize: 24,
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 50),
            Divider(
              height: 2,
              thickness: 2,
              indent: 2,
              endIndent: 2,
              color: context.colorScheme.onSurface,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'Login');
                  },
                  child: Container(
                    height: 50,
                    width: screenWidth / 2.5,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginPage(fromRegister: true),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    height: 50,
                    width: screenWidth / 2.5,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
                child: Text(
                  "This App is made By Astronicker",
                  style: TextStyle(
                    fontSize: 16,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
