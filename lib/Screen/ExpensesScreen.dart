import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/Screen/AddExpenseScreen.dart';
import 'package:we_spilit/common/helper/helper.dart';
import 'package:we_spilit/provider/friends_provider.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final double verticalPadding = screenHeight * 0.02; // 2% of screen height
    final double buttonFontSize = screenWidth * 0.04; // 4% of screen width
    final double titleFontSize = screenWidth * 0.05; // 5% of screen width
    final double subtitleFontSize = screenWidth * 0.04; // 4% of screen width

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
              SizedBox(height: verticalPadding * 2), // Adjust top padding
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddExpenseScreen(),
                          ),
                        );
                      },
                      label: Text(
                        "Add Expenses",
                        style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(Icons.currency_rupee_outlined),
                    )
                  ],
                ),
              ),
              Consumer<FriendsProvider>(builder: (context, provider, child) {
                return Expanded(
                  child: provider.getExpense().isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome to We Split, User!',
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              Text('You do not have any Expenses yet.'),
                              SizedBox(height: verticalPadding * 2),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.getExpense().length,
                          itemBuilder: (context, index) {
                            final expense = provider.getExpense()[index];
                            return Dismissible(
                              key: Key(DateTime.now().millisecond.toString()),
                              direction: DismissDirection.endToStart,
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
                                            provider
                                                .deleteExpense(expense.fId)
                                                .then((value) =>
                                                    Navigator.of(context)
                                                        .pop());
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: ListTile(
                                title: Text(
                                    joinString(expense.fName, expense.lName)),
                                subtitle: Text(
                                    'Members: ${expense.members} | Amount: ₹${divideAmount(expense.amount!, expense.members!)}',
                                    style:
                                        TextStyle(fontSize: subtitleFontSize)),
                              ),
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
}
