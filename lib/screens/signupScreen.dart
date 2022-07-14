//ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/responsive/responsiveLayoutScreen.dart';
import 'package:instagram_clone/responsive/webScreenLayout.dart';
import 'package:instagram_clone/screens/loginScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/textFieldInput.dart';
import '../resources/authMethods.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// Controllers get the data from input fields ad store it. We can then access that data in the future.
class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List?
      _image; // We store image in firebase storage using Uint8List instead of File because File doesn't work in web.
  bool _isLoading = false; // variable to display circular loading indicator.

  @override
  void dispose() {
    // dispose of controllers when screen is closed.
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Call this function when Sign Up button is Pressed.
  //This Methods gets data from controllers and sends it to firebase using the signUp method in AuthMethods.dart
  // PROCESS: 1. Get data from controllers. 2. Call signupUser method in signup screen which calls SignupUser method i AuthMethods class.
  //          3. Display error message if any. 4. Store data in Firebase Database 5. Store Images in Firebase Storage
  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
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

  //When clicked on "already have an account  log in" -> this will route to the login screen.
  void navigateToLoginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  //Method to select Image from Gallery while signing Up. This method is called when user clicks on the icon at the bottom of the image.
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img; // Store the Uint8List image in _image global variable.
    });
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
              Stack(
                children: [
                  _image !=
                          null // Tertiary operator which displays a default profile pic until user selects an image from gallety
                      ? CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/564x/63/0b/c2/630bc2282fffdc8ebd47ce14c12e90c1.jpg'),
                        ),
                  Positioned(
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed:
                            selectImage, // Select image method called which gets the image from gallery and stores it in _image global variable.
                      ),
                      bottom: -10,
                      left: 80),
                ],
              ),
              SizedBox(height: 20),
              TextFieldInput(
                // For Email Field
                hintText: 'Enter your Username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              SizedBox(height: 20),
              TextFieldInput(
                // For Email Field
                hintText: 'Enter your Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              SizedBox(height: 20),
              TextFieldInput(
                // For Email Field
                hintText: 'Enter your Bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
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
                onTap: signupUser,
                child: Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Text(
                          'Sign up',
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
                    child: Text('Already have an account?'),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: navigateToLoginScreen,
                    child: Container(
                      child: Text(
                        'Log in',
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
