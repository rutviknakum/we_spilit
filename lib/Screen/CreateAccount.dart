import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/MainScreen.dart';
import 'package:we_spilit/Screen/LoginScreen.dart';
import 'package:we_spilit/provider/auth_provider.dart';
import 'package:we_spilit/provider/friends_provider.dart';
import 'package:we_spilit/provider/user_provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true; // Track the password visibility

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Text(
            'Successfully created your account!',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'asset/background.jpeg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        child: Image.asset(
                      'asset/logo.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                    )),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone no.',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context);
                          final provider = context.read<AuthenticateProvider>();
                          final userProvider = context.read<UserProvider>();
                          final user = await provider.createEmailAccount(
                              userEmailController.text,
                              passwordController.text);
                          if (user != null) {
                            await userProvider.setUserData(
                                id: user.uid,
                                userName: userNameController.text,
                                userEmail: user.email!,
                                phoneNumber: phoneNumberController.text);
                            _showSuccessDialog(); // Show success dialog
                          } else {
                            print('User is not created');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final nav = Navigator.of(context);
                        final authProvider =
                            context.read<AuthenticateProvider>();
                        final userProvider = context.read<UserProvider>();
                        final friendsProvider = context.read<FriendsProvider>();
                        final userCredential =
                            await authProvider.loginWithGoogle();
                        final user = userCredential?.user;
                        if (user != null) {
                          await friendsProvider.getAllFriends();
                          await userProvider.setUserData(
                            userName: user.displayName ?? '',
                            userEmail: user.email ?? '',
                            id: user.uid,
                          );
                          nav.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      icon: Image.asset(
                        'asset/google_icon.png',
                        height: 50,
                      ),
                      label: const Text(
                        'Sign-In with Google',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white, // Text and icon color
                        minimumSize: const Size(
                            double.infinity, 50), // Set width and height
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Already have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: TextButton(
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'SIGN IN',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
