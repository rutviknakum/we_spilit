import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/Screen/LoginScreen.dart';
import 'package:we_spilit/provider/auth_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int? _pressedIndex;
  bool _isDarkMode = false; // Dummy variable for theme toggle

  @override
  Widget build(BuildContext context) {
    final userCredentials =
        FirebaseAuth.instance.currentUser?.email ?? 'Unknown User';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'asset/background.jpeg', // Ensure this path is correct
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Text(
                      'Logged in as: $userCredentials',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildListTile(
                    context,
                    index: 0,
                    icon: Icons.show_chart,
                    title: 'Activity',
                  ),
                  _buildListTile(
                    context,
                    index: 1,
                    icon: Icons.notifications,
                    title: 'Notification',
                  ),
                  // Dummy Theme Toggle
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text(
                      'Theme',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value; // Just toggles the switch
                        });
                      },
                    ),
                  ),
                  // Delete Account Option
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete Account',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    onTap: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _showLogoutConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'LOGOUT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required int index, required IconData icon, required String title}) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedIndex = index;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressedIndex = null;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressedIndex = null;
        });
      },
      child: Container(
        color:
            _pressedIndex == index ? Colors.grey.shade300 : Colors.transparent,
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          tileColor: Colors.transparent,
          hoverColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'Do you really want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Handle delete account functionality here
              },
              child: const Text('Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Do you really want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18)),
            ),
            Consumer<AuthenticateProvider>(builder: (context, provider, child) {
              return TextButton(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  await provider.logout();
                  nav.pop(); // Close the dialog
                  nav.pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreen()), // Navigate to LoginScreen
                  );
                },
                child: const Text('Yes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18)),
              );
            }),
          ],
        );
      },
    );
  }
}

class UserCredentials {
  static final UserCredentials _instance = UserCredentials._internal();

  String? _credentials;

  factory UserCredentials() {
    return _instance;
  }

  UserCredentials._internal();

  void setCredentials(String credentials) {
    _credentials = credentials;
  }

  String? get credentials => _credentials;
}
