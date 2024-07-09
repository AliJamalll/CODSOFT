import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/providers/user_provider.dart';
import 'package:personal_expense_tracker/screens/login_screen.dart';
import 'package:personal_expense_tracker/utiles/colors.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

   addData()async{
   UserProvider _userProvider = Provider.of(context, listen: false);
   await _userProvider.refreshUser();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height:70,
              ),
              Stack(
                children: [
                  Image.asset(
                  'assets/images/onboarding2.png'
                ),
                  Positioned(
                    top:-17,
                      child: Image.asset(
                        'assets/images/onboarding3.png'
                      )
                  )
                ]
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                'Make Your Financial Management Easier',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Financy is a mobile application that can help you manage your finances in a simple way.',
                style: TextStyle(
                    fontSize: 20,
                ),
              ),
              Spacer(),
              MaterialButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => LoginScreen()
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 130),//105
                  height: 50,
                  decoration: BoxDecoration(
                    color: KPrimaryColor,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Row(
                    children: [
                      Text('Let\'s start',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

