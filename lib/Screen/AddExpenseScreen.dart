import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_spilit/common/helper/helper.dart';
import 'package:we_spilit/model/friend_model.dart';
import 'package:we_spilit/provider/friends_provider.dart';
import 'package:we_spilit/provider/search_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final searchNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final memberController = TextEditingController();

  FriendsModel? searchFriend;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final responsivePadding =
        EdgeInsets.symmetric(horizontal: screenWidth * 0.05);

    print(context.read<FriendsProvider>().getFriend());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Image.asset(
                'asset/background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: responsivePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Center(
                    child: Text(
                      'Add an expense',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'With you and:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    controller: searchNameController,
                    onChanged: (value) {
                      context.read<SearchProvider>().searchEvent(
                          value.trim().toLowerCase(),
                          context
                              .read<FriendsProvider>()
                              .getFriend()
                              .map((e) => joinString(e.fName, e.lName)
                                  .trim()
                                  .toLowerCase())
                              .toList());
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter name',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Consumer<SearchProvider>(
                    builder: (context, provider, child) {
                      final searchResults = provider.searchResult;
                      return searchResults.isNotEmpty
                          ? _buildSearchResults(
                              searchResults, context, screenHeight)
                          : _buildExpenseForm(
                              context, screenWidth, screenHeight);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
      List<String> searchResults, BuildContext context, double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 2)],
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        itemCount: searchResults.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final searchResult = searchResults[index];
          final searchData =
              context.read<FriendsProvider>().addSearchData(searchResult);
          return GestureDetector(
            onTap: () {
              setState(() {
                searchNameController.text = searchResult;
                searchFriend = searchData;
                context.read<SearchProvider>().clearSearch();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Text(
                searchResult,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            thickness: 1,
            height: screenHeight * 0.01,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget _buildExpenseForm(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchFriend != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Text(
              joinString(searchFriend?.fName ?? '', searchFriend?.lName ?? ''),
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
        SizedBox(height: screenHeight * 0.02),
        _buildTextFieldWithIcon(
          context,
          icon: Icons.description,
          controller: descriptionController,
          hintText: 'Enter a description',
        ),
        SizedBox(height: screenHeight * 0.02),
        _buildTextFieldWithIcon(
          context,
          icon: Icons.currency_rupee,
          controller: amountController,
          hintText: '0.00',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: screenHeight * 0.02),
        _buildTextFieldWithIcon(
          context,
          icon: Icons.person_2_rounded,
          controller: memberController,
          hintText: 'No of members',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: screenHeight * 0.04),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05),
          child: Text(
            'Paid by you and split equally',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        Center(
          child: ElevatedButton(
            onPressed: () => _addExpense(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.2,
                vertical: screenHeight * 0.02,
              ),
              textStyle: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text(
              'Add Expense',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithIcon(
    BuildContext context, {
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: screenWidth * 0.07,
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: const UnderlineInputBorder(),
            ),
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }

  void _addExpense(BuildContext context) {
    if (searchFriend != null &&
        descriptionController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        memberController.text.isNotEmpty) {
      final friendsModel = FriendsModel(
        fId: searchFriend!.fId,
        userId: searchFriend!.userId,
        fName: searchFriend!.fName,
        lName: searchFriend!.lName,
        fPhoneNumber: searchFriend!.fPhoneNumber,
        description: descriptionController.text,
        amount: int.tryParse(amountController.text) ?? 0,
        members: int.tryParse(memberController.text) ?? 1,
      );
      _showSuccessDialog(context, friendsModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields and select a friend.'),
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, FriendsModel friendsModel) {
    final screenWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          content: const Text('Expenses added successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await context
                    .read<FriendsProvider>()
                    .setFireStoreExpanse(friendsModel: friendsModel);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close screen
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
