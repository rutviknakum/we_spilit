import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/model/group_model.dart';
import 'package:we_spilit/provider/friends_provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final groupName = TextEditingController();
  String? type;
  List<String> selectedFriends = [];

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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 24),
                          onPressed: () {
                            _showCancelConfirmationDialog(context);
                          },
                        ),
                        const Text(
                          'Create Group',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: groupName,
                    decoration: const InputDecoration(
                      labelText: 'Group name',
                      prefixIcon: Icon(Icons.group_outlined),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildElevatedButton(Icons.home, 'Home', () {
                            setState(() {
                              type = 'Home';
                            });
                          }),
                          _buildElevatedButton(Icons.flight, 'Trip', () {
                            setState(() {
                              type = 'Trip';
                            });
                          }),
                          _buildElevatedButton(
                              Icons.person_2_outlined, 'Friend', () {
                            setState(() {
                              type = 'Friend';
                            });
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildElevatedButton(Icons.food_bank, 'Foodiee', () {
                            setState(() {
                              type = 'Foodiee';
                            });
                          }),
                          _buildElevatedButton(Icons.person_4_sharp, 'Buddy',
                              () {
                            setState(() {
                              type = 'Buddy';
                            });
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildElevatedButton(Icons.person_3_rounded, 'Cousin',
                              () {
                            setState(() {
                              type = 'Cousin';
                            });
                          }),
                          _buildElevatedButton(Icons.more, 'Other', () {
                            setState(() {
                              type = 'Other';
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                  if (type != null) ...{
                    const SizedBox(height: 30),
                    Align(child: Text('Type : ${type}')),
                  },
                  const SizedBox(height: 30),
                  const Text(
                    'Select Friends',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<FriendsProvider>(
                    builder: (context, provider, child) {
                      if (provider.getFriend().isEmpty) {
                        return const Center(
                          child: Text('No friends available.'),
                        );
                      }
                      return Column(
                        children: provider.getFriend().map((friend) {
                          return CheckboxListTile(
                            title: Text('${friend.fName} ${friend.lName}'),
                            value: selectedFriends.contains(friend.fId),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedFriends.add(friend.fId);
                                } else {
                                  selectedFriends.remove(friend.fId);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (groupName.text.isNotEmpty && type != null) {
                          _showAddGroupConfirmationDialog(
                            context,
                            groupName.text,
                            type!,
                            selectedFriends,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        'Add Group!',
                        style: TextStyle(
                          color: Colors.black,
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

  Widget _buildElevatedButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
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
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showAddGroupConfirmationDialog(BuildContext context, String groupName,
      String type, List<String> selectedFriends) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Group created successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final groupId = DateTime.now().millisecondsSinceEpoch;
                final groupModel = GroupModel(
                  groupId: groupId.toString(),
                  groupName: groupName,
                  groupType: type,
                  friends: selectedFriends, // Corrected parameter name
                );
                context
                    .read<FriendsProvider>()
                    .setFirebaseGroupData(groupModel);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
