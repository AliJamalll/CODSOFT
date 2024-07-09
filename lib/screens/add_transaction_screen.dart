import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/providers/user_provider.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';
import 'package:personal_expense_tracker/utiles/colors.dart';
import 'package:personal_expense_tracker/models/user_model.dart' as model;
import 'package:personal_expense_tracker/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  String transactionType = 'income'; // Default value

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    amountController.dispose();
    noteController.dispose();
    totalController.dispose();
    super.dispose();
  }

  Future<void> _addTransaction() async {
    if (_dateController.text.isEmpty || amountController.text.isEmpty || noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    model.User currentUser = Provider.of<UserProvider>(context, listen: false).getUser!;

    int amount = int.tryParse(amountController.text) ?? 0;
    int currentTotal = currentUser.total ?? 0;  // Use default value 0 if total is null
    int newTotal = transactionType == 'Income' ? currentTotal + amount : currentTotal - amount;

    model.User updatedUser = model.User(
      // Add fields here as per your User model
      email: currentUser.email,
      uid: currentUser.uid,
      username: currentUser.username,
      total: newTotal,
      amount: amount,
      date: DateTime.tryParse(_dateController.text),
      note: noteController.text,
      type: transactionType,
    );

    try {
      await Provider.of<UserProvider>(context, listen: false).addUserDetails(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction added successfully')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add transaction: $e')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Add Transactions',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/trans.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.monitor_heart, color: Colors.yellow),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            hintText: 'current budget',
                            textInputType: TextInputType.number,
                            controller: totalController,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.attach_money, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            hintText: 'The amount',
                            textInputType: TextInputType.number,
                            controller: amountController,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.note_alt_outlined, color: Colors.blueAccent),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Note on transaction',
                            textInputType: TextInputType.text,
                            controller: noteController,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.transfer_within_a_station, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                transactionType = 'Income';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: transactionType == 'Income' ? Colors.blueAccent : Colors.grey,
                              ),
                              child: Row(
                                children: [
                                  Text('Income'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                transactionType = 'Outcome';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 21),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: transactionType == 'Outcome' ? Colors.red : Colors.grey,
                              ),
                              child: Row(
                                children: [
                                  Text('Outcome'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.date_range, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Select Date',
                            textInputType: TextInputType.datetime,
                            onTap: () => _selectDate(context),
                            controller: _dateController,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                MaterialButton(
                  onPressed: _addTransaction,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 130),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Add',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
