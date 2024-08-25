import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/Screen/CreateGroupScreen.dart';
import 'package:we_spilit/common/widgets/circular_progress.dart';
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
                              builder: (context) => const CreateGroupScreen()),
                        );
                      },
                      label: const Text(
                        "Create Groups",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(Icons.group_add),
                    )
                  ],
                ),
              ),

              Consumer<FriendsProvider>(
                  builder: (context, provider, child) {
                    return Expanded(
                      child: StreamBuilder<List<GroupModel>?>(
                        stream: provider.getGroupData(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: showProgress(),
                            );
                          }
                          if(!snapshot.hasData){
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
                                key: Key(data.groupName +
                                    data.groupType),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  // setState(() {
                                  //   expenses.removeAt(index);
                                  // });
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //       content: Text(
                                  //           '${expense.user}\'s expense deleted')),
                                  // );
                                },
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text(
                                            'Are you sure you want to delete this expense?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              provider.deleteGroup(data.groupId);
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
                                  subtitle: Text(
                                      'Type: ${data.groupType}'),
                                ),
                              );
                            },
                          );
                        }
                      ),
                    );
                  }
              ),

            ],
          ),
        ],
      ),
    );
  }
}
