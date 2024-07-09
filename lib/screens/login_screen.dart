import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/resources/auth_methods.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';
import 'package:personal_expense_tracker/screens/signup_screen.dart';
import 'package:personal_expense_tracker/utiles/colors.dart';
import 'package:personal_expense_tracker/utiles/utils.dart';
import 'package:personal_expense_tracker/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signInUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signInUser(
        email: _emailController.text,
        password: _passwordController.text
    );
    setState(() {
      _isLoading = false;
    });
    if(res == "success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
          (context) =>  HomeScreen()
      ));    }else{
      ShowSnackBar(res,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(),flex: 2,),
                Text('Financy',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: KPrimaryColor
                  ),
                ),
                SizedBox(
                  height: 44,
                ),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signInUser,
                  child: Container(
                    child:_isLoading ?  Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    ),) : const Text(
                        'Log in'
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                        ),
                        color: KPrimaryColor
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Flexible(child: Container(),flex: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'don\'t have an account?',
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: NavToSignUp,
                      child: Container(
                        child: const Text(
                          ' Sign up',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  void NavToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(builder:
        (context){
      return SignUpScreen();
    }
    ));
  }
}
