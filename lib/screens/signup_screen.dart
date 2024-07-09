import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/resources/auth_methods.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';
import 'package:personal_expense_tracker/screens/login_screen.dart';
import 'package:personal_expense_tracker/utiles/colors.dart';
import 'package:personal_expense_tracker/utiles/utils.dart';
import 'package:personal_expense_tracker/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }



  void SignUpUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().SingUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,

    );
    setState(() {
      _isLoading = false;
    });
    if(res != 'success'){
      ShowSnackBar(res ,context);
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
          (context) => LoginScreen()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
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
              /// Circle avatar
              CustomTextField(
                controller: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 24,
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
                onTap: SignUpUser,
                child: Container(
                  child: _isLoading ? Center(child: CircularProgressIndicator(
                    color: Colors.white,
                  ),) :const Text('Sign up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    color: KPrimaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      'have an account?',
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: NavToLogIn,
                    child: Container(
                      child: const Text(
                        ' Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void NavToLogIn() {
    Navigator.of(context).push(MaterialPageRoute(builder:
        (context){
      return LoginScreen();
    }
    ));
  }
}
