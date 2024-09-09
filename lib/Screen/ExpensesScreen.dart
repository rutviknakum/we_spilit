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
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalPadding = screenHeight * 0.02;
    final double buttonFontSize = screenWidth * 0.04;
    final double titleFontSize = screenWidth * 0.05;
    final double subtitleFontSize = screenWidth * 0.04;

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
              SizedBox(height: verticalPadding * 2),
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
                                onTap: () {
                                  _showExpenseDetailsPopup(context, expense);
                                },
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

  // This method shows the popup with expense details
  void _showExpenseDetailsPopup(BuildContext context, expense) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            joinString(expense.fName, expense.lName),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: ₹${expense.amount}'),
              Text('Members: ${expense.members}'),
              SizedBox(height: 10),
              Text('Description: ${expense.description}'),
              SizedBox(height: 20),
              // Red line and "Paid by"
              Divider(color: Colors.red, thickness: 1),
              Text(
                'Paid by ${joinString(expense.fName, expense.lName)}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }
}
