import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor/Firebase/download.dart' as custom;
import 'package:donor/Theme/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 36,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab(
                  label: 'Requests',
                  selected: isSelected,
                  onTap: () => setState(() => isSelected = true),
                ),
                _buildTab(
                  label: 'My requests',
                  selected: !isSelected,
                  onTap: () => setState(() => isSelected = false),
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Main list area with flexible space
            Expanded(
              child: isSelected
                  ? const RequestListPage()
                  : const MyRequestListPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: selected ? context.colorScheme.primary : null,
            ),
          ),
          const SizedBox(height: 15),
          Visibility(
            visible: selected,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Container(
              height: 2,
              width: 150,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class MyRequestListPage extends StatefulWidget {
  const MyRequestListPage({super.key});

  @override
  State<MyRequestListPage> createState() => _MyRequestListPageState();
}

class _MyRequestListPageState extends State<MyRequestListPage> {
  List<Map<String, dynamic>> requestList = [];

  // Define state variables
  String? name,
      blood,
      city,
      state,
      hospital,
      phone,
      date,
      age,
      units,
      documentId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        custom.DownloadPage(
          collection: 'requests',
          queryBuilder: (ref) => ref.where('uid', isEqualTo: currentUserId),
          onData: (docs) {
            if (docs.isNotEmpty) {
              final allData = docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  requestList = allData;
                });
              });
            }
          },
        ),

        Expanded(
          child: requestList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: requestList.length,
                  itemBuilder: (context, index) {
                    final request = requestList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${request['name']}'),
                                    Text('Age: ${request['age']}'),
                                    Text('Blood: ${request['blood']}'),
                                    Text('Hospital: ${request['hospital']}'),
                                    Text(
                                      'City: ${request['city']},${request['state']}',
                                    ),

                                    Text('Units: ${request['units']}'),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Request'),
                                      content: const Text(
                                        'Are you sure you want to delete this request?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await FirebaseFirestore.instance
                                        .collection('requests')
                                        .doc(request['id'])
                                        .delete();
                                  }
                                },
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phone: ${request['phone']}'),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text('${request['date']}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(child: const CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  List<Map<String, dynamic>> requestList = [];

  String? name, blood, city, state, hospital, phone, date, age, units;
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Column(
      children: [
        custom.DownloadPage(
          collection: 'requests',
          queryBuilder: (ref) => ref.where('uid', isNotEqualTo: currentUserId),
          onData: (docs) {
            if (docs.isNotEmpty) {
              final allData = docs.map((doc) {
                final data = doc.data();
                return data;
              }).toList();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  requestList = allData;
                });
              });
            }
          },
        ),

        Expanded(
          child: requestList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: requestList.length,
                  itemBuilder: (context, index) {
                    final request = requestList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${request['name']}'),
                                    Text('Age: ${request['age']}'),
                                    Text('Blood: ${request['blood']}'),
                                    Text('Hospital: ${request['hospital']}'),
                                    Text(
                                      'City: ${request['city']},${request['state']}',
                                    ),

                                    Text('Units: ${request['units']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phone: ${request['phone']}'),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text('${request['date']}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(child: const CircularProgressIndicator()),
        ),
      ],
    );
  }
}
