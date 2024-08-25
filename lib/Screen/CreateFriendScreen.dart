import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/MainScreen.dart';
import 'package:we_spilit/provider/friends_provider.dart';

class CreateFriendScreen extends StatefulWidget {
  const CreateFriendScreen({super.key});

  @override
  State<CreateFriendScreen> createState() => _CreateFriendScreenState();
}

class _CreateFriendScreenState extends State<CreateFriendScreen> {
  final fName = TextEditingController();
  final lName = TextEditingController();
  final fPhoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'asset/background.jpeg', // Update with your image path
            fit: BoxFit.cover,
          ),
          // Content on top of the background
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container to adjust the position of the Row with back icon, title, and buttons
                  Container(
                    padding:
                        const EdgeInsets.only(top: 40.0), // Adjust top padding
                    child: Row(
                      children: [
                        // Back button
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 24),
                          onPressed: () {
                            _showCancelConfirmationDialog(context);
                          },
                        ),
                        // Title
                        const Text(
                          'Create Friend',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        // Save button
                        // TextButton(
                        //   onPressed: () {
                        //     _showSaveConfirmationDialog(context);
                        //   },
                        //   child: const Text(
                        //     'Save',
                        //     style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Group name field
                  TextField(
                    controller: fName,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors
                          .white, // Optional: To ensure text field is visible
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: lName,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors
                          .white, // Optional: To ensure text field is visible
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: fPhoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: Icon(Icons.numbers),
                      filled: true,
                      fillColor: Colors
                          .white, // Optional: To ensure text field is visible
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Add Friend button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (fName.text.isNotEmpty &&
                            lName.text.isNotEmpty &&
                            fPhoneNumber.text.isNotEmpty) {
                          _showAddFriendConfirmationDialog(context, fName.text,
                              lName.text, fPhoneNumber.text);
                        } else {
                          print('Please fill all field');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Add Friend!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Saved successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Do you really want to cancel? Any unsaved changes will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the CreateGroupScreen
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showAddFriendConfirmationDialog(
      BuildContext context, String fName, String lName, String fPhoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Friend added successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await context
                    .read<FriendsProvider>()
                    .setFireStoreFriends(
                        fName: fName, lName: lName, fPhoneNumber: fPhoneNumber)
                    .then(
                  (value) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen(),), (route) => false,);
                  },
                );
                // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
