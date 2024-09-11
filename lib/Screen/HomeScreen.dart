import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/Screen/CreateFriendScreen.dart';
import 'package:we_spilit/common/helper/helper.dart';
import 'package:we_spilit/model/friend_model.dart';
import 'package:we_spilit/provider/friends_provider.dart';

class Friend {
  final String firstName;
  final String lastName;
  final String googlePayBarcode;
  final double sharedExpenses;

  Friend({
    required this.firstName,
    required this.lastName,
    required this.googlePayBarcode,
    required this.sharedExpenses,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'asset/background.jpeg',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              const SizedBox(height: 50), // Adjust the top padding as needed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateFriendScreen()),
                        );
                      },
                      label: const Text(
                        "Add new Friends",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(Icons.person_add),
                    )
                  ],
                ),
              ),
              Consumer<FriendsProvider>(
                  builder: (context, friendProvider, child) {
                return Expanded(
                  child: Consumer<FriendsProvider>(
                      builder: (context, provider, child) {
                    if (provider.getFriend().isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to We Split, User!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('You have not added any friends yet.'),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.getFriend().length,
                      itemBuilder: (context, index) {
                        final friend = provider.getFriend()[index];

                        return Dismissible(
                          key: Key(DateTime.now().microsecond.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Confirm Deletion',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  content: const Text(
                                      'Are you sure you want to delete this friend?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        provider.deleteFriends(friend.fId).then(
                                            (value) =>
                                                Navigator.of(context).pop());
                                      },
                                      child: const Text(
                                        'Delete',
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
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: ListTile(
                            title: Text('${friend.fName} ${friend.lName}'),
                            subtitle: friend.amount == null ||
                                    friend.amount == 0
                                ? const Text('No any Expenses')
                                : Text(
                                    'Shared Expenses: ₹${divideAmount(friend.amount!, friend.members!)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: () {
                                _showFriendDetailsDialog(context, friend);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showFriendDetailsDialog(
      BuildContext context, FriendsModel friendModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${friendModel.fName} ${friendModel.lName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'asset/qr.jpeg',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                  'Shared Expenses: \$${friendModel.amount?.toStringAsFixed(2) ?? "0.00"}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
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
}
