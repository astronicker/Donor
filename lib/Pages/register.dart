import 'package:donor/Firebase/upload.dart';
import 'package:donor/Theme/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donor/Widgets/textbox.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool uploadDone = false;

  RegisterPage({super.key});

  Future<void> handleUpload(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await upload(
        collection: 'users',
        documentId: uid,
        data: {
          'uid': uid,
          'name': nameController.text,
          'age': ageController.text,
          'blood': bloodController.text,
          'gender': genderController.text,
          'city': cityController.text,
          'state': stateController.text,
        },
      );
      uploadDone = true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Kindly fill all the details to register with Donor.",
                style: TextStyle(
                  fontSize: 20,
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
              TextBox(
                hintText: 'Name',
                controller: nameController,
                borderRadius: BorderRadius.circular(25),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextBox(
                      maxLenght: 2,
                      inputType: TextInputType.number,
                      hintText: 'Age',
                      controller: ageController,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextBox(
                      maxLenght: 2,
                      hintText: 'Blood',
                      controller: bloodController,
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  const SizedBox(width: 5),

                  Expanded(
                    child: TextBox(
                      hintText: 'Gender',
                      controller: genderController,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextBox(
                      hintText: 'City',
                      controller: cityController,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  Expanded(
                    child: TextBox(
                      hintText: 'State',
                      controller: stateController,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      bloodController.text.isNotEmpty &&
                      genderController.text.isNotEmpty &&
                      cityController.text.isNotEmpty &&
                      stateController.text.isNotEmpty) {
                    await handleUpload(context);
                    if (uploadDone) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'Home',
                        (route) => false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all details'),
                        duration: Duration(seconds: 1),
                      ),
                    );
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
                      'Continue',
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
        ),
      ),
    );
  }
}
