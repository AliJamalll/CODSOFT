import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/user_model.dart' as model;
import 'package:personal_expense_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CustomListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    model.User currentUser = Provider.of<UserProvider>(context, listen: false).getUser!;

    List<model.User> transactions = [currentUser];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        model.User transaction = transactions[index];

        // Debugging print
        print('Transaction type: ${transaction.type}, Amount: ${transaction.amount}');

        bool isIncome = transaction.type?.toLowerCase() == 'income';

        return Container(
          height: 100,
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        transaction.note ?? 'No note',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        transaction.date?.toLocal().toString().split(' ')[0] ?? 'No date',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      isIncome ? '+ ${transaction.amount} \$' : '- ${transaction.amount} \$',
                      style: TextStyle(
                        fontSize: 18,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
