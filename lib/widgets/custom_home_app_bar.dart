import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/providers/user_provider.dart';
import 'package:personal_expense_tracker/utiles/colors.dart';
import 'package:personal_expense_tracker/screens/add_transaction_screen.dart';
import 'package:personal_expense_tracker/models/user_model.dart' as model;
import 'package:provider/provider.dart';


class CustomHomeAppBar extends StatefulWidget {
  const CustomHomeAppBar({super.key});

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {

  late Stream<List<model.User>> userStream;

  @override
  void initState() {
    super.initState();
    userStream = _getUserTransactionsStream();
  }

  Stream<List<model.User>> _getUserTransactionsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return model.User.fromSnap(doc);
      }).toList();
    })
        .handleError((error) {
      print('Error in stream: $error');
    });
  }

  Future<void> _refreshHomeScreen() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshHomeScreen();
    setState(() {
      userStream = _getUserTransactionsStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
              'assets/images/pic.jpg'
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome again!',
            style: TextStyle(fontSize: 18),),
            Text(
              user.username!,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ],
        ),

        Spacer(),
        IconButton(
          icon: Icon(Icons.refresh,color: mobileBackgroundColor,),
          onPressed: _refreshHomeScreen, // Refresh when the button is pressed
        ),
        TextButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddTransactionScreen()));
            },
            child: Text(
              'add',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KPrimaryColor
              ),
            )
        )
      ],
    );
  }
}
