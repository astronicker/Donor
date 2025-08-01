import 'package:donor/Firebase/upload.dart';
import 'package:donor/Theme/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donor/Widgets/textbox.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController datetimeController = TextEditingController();

  bool uploadDone = false;

  Future<bool> handleUpload(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await upload(
        collection: 'requests',
        data: {
          'uid': uid,
          'name': nameController.text.trim(),
          'age': ageController.text.trim(),
          'blood': bloodController.text.trim(),
          'gender': genderController.text.trim(),
          'city': cityController.text.trim(),
          'state': stateController.text.trim(),
          'hospital': hospitalController.text.trim(),
          'phone': phoneController.text.trim(),
          'units': unitsController.text.trim(),
          'date': datetimeController.text.trim(),
        },
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Donor',
                style: TextStyle(
                  fontSize: 36,
                  color: context.colorScheme.primary,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Profile');
                  },
                  icon: Icon(Icons.person),
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          SingleChildScrollView(
            child: Column(
              children: [
                TextBox(
                  hintText: 'Patient name',
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
                        maxLenght: 3,
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
                        maxLenght: 6,
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
                TextBox(
                  hintText: 'Hostpital',
                  controller: hospitalController,
                  borderRadius: BorderRadius.circular(25),
                ),
                const SizedBox(height: 15),
                TextBox(
                  maxLenght: 10,
                  inputType: TextInputType.phone,
                  hintText: 'Contact number',
                  controller: phoneController,
                  borderRadius: BorderRadius.circular(25),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextBox(
                        hintText: 'Units',
                        inputType: TextInputType.phone,
                        maxLenght: 2,
                        controller: unitsController,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),

                    Expanded(
                      child: TextBox(
                        hintText: 'Date',
                        maxLenght: 10,
                        inputType: TextInputType.datetime,
                        controller: datetimeController,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () async {
                    if (nameController.text.isNotEmpty &&
                        ageController.text.isNotEmpty &&
                        bloodController.text.isNotEmpty &&
                        genderController.text.isNotEmpty &&
                        cityController.text.isNotEmpty &&
                        stateController.text.isNotEmpty &&
                        hospitalController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty &&
                        unitsController.text.isNotEmpty &&
                        datetimeController.text.isNotEmpty) {
                      final success = await handleUpload(
                        context,
                      ); // ✅ Await upload

                      if (success) {
                        if (!context.mounted) return;

                        // ✅ Show success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Request Sent'),
                              content: const Text(
                                'Your request has been sent to all the users.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );

                        // ✅ Clear input fields
                        nameController.clear();
                        ageController.clear();
                        bloodController.clear();
                        genderController.clear();
                        cityController.clear();
                        stateController.clear();
                        hospitalController.clear();
                        phoneController.clear();
                        unitsController.clear();
                        datetimeController.clear();
                      } else {
                        // Optional: Show error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Upload failed, try again'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all data')),
                      );
                    }
                  },

                  child: Container(
                    width: double.infinity,
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
        ],
      ),
    );
  }
}
