//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/authMethods.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/responsive/responsiveLayoutScreen.dart';
import 'package:instagram_clone/responsive/webScreenLayout.dart';
import 'package:instagram_clone/screens/signupScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/textFieldInput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Varibale to display the loading indicator.

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // This method is called when the user taps the Login button.
  //It calls the loginUser method in the AuthMethods class which compares email and password with the ones in the database.
  //If data matches, user is logged in
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res != 'Success!') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  //When clicked on "Don't have an account  Sign Up" -> this will route to the login screen.
  void navigateToSignupScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      ),
    );
  }

  //SCREEN UI STARTS FROM HERE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 54,
              ),
              SizedBox(height: 32),
              TextFieldInput(
                // For Email Field
                hintText: 'Enter Email or Username',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              SizedBox(height: 20),
              TextFieldInput(
                // For Password Field
                hintText: 'Password',
                textInputType: TextInputType.visiblePassword,
                textEditingController: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              InkWell(
                // For the Login Button
                onTap:
                    loginUser, //When Login Button is pressed-> loginUser method is called which calls a method in AuthMethods class to compare data.
                child: Container(
                  child:
                      _isLoading //Tertiary operator which displays a circular progress indicator if _isLoading is true til the loginUser func is being called.
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Don\'t have an account?'),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: navigateToSignupScreen,
                    child: Container(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: blueColor),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
