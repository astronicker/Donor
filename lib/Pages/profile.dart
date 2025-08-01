import 'package:donor/Theme/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name, blood, city, state, gender, age;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (currentUserId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          name = data['name'];
          age = data['age'];
          blood = data['blood'];
          gender = data['gender'];
          city = data['city'];
          state = data['state'];
        });
      }
    }
  }

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
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'Home',
                  (route) => false,
                );
              },
              child: Text(
                '<',
                style: TextStyle(
                  fontSize: 35,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.person, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${name ?? '...'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text('Age: ${age ?? '...'}', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(
                    'Blood: ${blood ?? '...'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Gender: ${gender ?? '...'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'City: ${city ?? '...'}, ${state ?? ''}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, 'Landing');
                }
              },
              child: Container(
                width: screenWidth,
                height: 56.6,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 18,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
