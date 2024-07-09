import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/models/user_model.dart' as model;
import 'package:personal_expense_tracker/providers/user_provider.dart';
import 'package:personal_expense_tracker/widgets/CustomListView.dart';
import 'package:personal_expense_tracker/widgets/custom_card.dart';
import 'package:personal_expense_tracker/widgets/custom_home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20, right: 10),
          child: RefreshIndicator(
            onRefresh: _refreshHomeScreen,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHomeAppBar(),
                  SizedBox(height: 20),
                  CustomCards(),
                  SizedBox(height: 20),
                  Text(
                    'Recent Transactions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 15),
                  StreamBuilder<List<model.User>>(
                    stream: userStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No transactions found.'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CustomListView();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
