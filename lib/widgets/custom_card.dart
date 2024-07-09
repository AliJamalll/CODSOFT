import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/user_model.dart' as model;
import 'package:personal_expense_tracker/providers/user_provider.dart';
import 'package:personal_expense_tracker/utiles/colors.dart';
import 'package:provider/provider.dart';

class CustomCards extends StatefulWidget {
  const CustomCards({Key? key});

  @override
  State<CustomCards> createState() => _CustomCardsState();
}

class _CustomCardsState extends State<CustomCards> {
  @override
  Widget build(BuildContext context) {
    model.User currentUser = Provider.of<UserProvider>(context, listen: false).getUser!;

    // Function to update the total balance
    int calculateTotalBalance(model.User user) {
      int total = user.total ?? 0;
      int amount = user.amount ?? 0;

      if (user.type == 'income') {
        total += amount;
      } else if (user.type == 'outcome') {
        total -= amount;
      }

      return total;
    }

    return Column(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          child: Card(
            color: Color(0xff808DD5),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.greenAccent,
                    size: 60,
                  ),
                  SizedBox(width: 13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Balance",
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        calculateTotalBalance(currentUser).toString(),
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 110,
          width: double.infinity,
          child: Card(
            color: KPrimaryColor,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          currentUser.type == 'Income' ? currentUser.amount.toString() : '0',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 1.0,
                    thickness: 2.0,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_upward, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Outcome",
                          style: TextStyle(fontSize: 23),
                        ),
                        Text(
                          currentUser.type == 'Outcome' ? currentUser.amount.toString() : '0',
                          style: TextStyle(fontSize: 25, color: currentUser.type == 'Outcome' ? Colors.white : Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
