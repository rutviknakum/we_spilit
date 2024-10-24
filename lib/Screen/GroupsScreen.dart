import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/Screen/CreateGroupScreen.dart';
import 'package:we_spilit/model/group_model.dart';
import 'package:we_spilit/provider/friends_provider.dart';

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'asset/background.jpeg', // Full-screen background image
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              const SizedBox(height: 50), // Adjust top padding if necessary
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
                            builder: (context) => const CreateGroupScreen(),
                          ),
                        );
                      },
                      label: const Text(
                        "Create Groups",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.group_add),
                    ),
                  ],
                ),
              ),
              Consumer<FriendsProvider>(builder: (context, provider, child) {
                return Expanded(
                  child: StreamBuilder<List<GroupModel>?>(
                    stream: provider.getGroupData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: circularProgress(), // Show loading spinner
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                              Text('You do not have any groups yet.'),
                              SizedBox(height: 20),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Dismissible(
                            key: Key(data.groupId),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              provider.deleteGroup(data.groupId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${data.groupName} deleted'),
                                ),
                              );
                            },
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                      'Are you sure you want to delete this group?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              title: Text(data.groupName),
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );

                                final friendsNames = await _getFriendsNames(
                                    context, provider, data.friends);

                                Navigator.pop(
                                    context); // Close the loading dialog

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(data.groupName),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Type: ${data.groupType}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Friends in Group:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (friendsNames.isEmpty)
                                            const Text('No friends found'),
                                          ...friendsNames
                                              .map((name) => Text(name))
                                              .toList(),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getFriendsNames(BuildContext context,
      FriendsProvider provider, List<String> friendsIds) async {
    final friendNames = <String>[];
    for (var id in friendsIds) {
      final name = await provider.getFriendNameById(id);
      if (name != null) {
        friendNames.add(name);
      } else {
        friendNames.add('Unknown'); // Handle case where name is not found
      }
    }
    return friendNames;
  }

  Widget circularProgress() {
    return const CircularProgressIndicator();
  }
}
