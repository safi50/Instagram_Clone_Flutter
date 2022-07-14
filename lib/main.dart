// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:instagram_clone/responsive/responsiveLayoutScreen.dart';
import 'package:instagram_clone/screens/loginScreen.dart';
import 'package:instagram_clone/screens/signupScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/responsive/webScreenLayout.dart';
import 'package:provider/provider.dart';

//This function Initializes the Firebase SDK.
Future<void> main() async {
  if (kIsWeb) {
    // This initializes the Firebase SDK for web.
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCMPzifR6M6vaVeTRKv3gYz5YsKyLRx5Ck',
        appId: '1:1097843469201:web:f627f00f3f91508b4ec830',
        messagingSenderId: '1097843469201',
        projectId: 'instagram-clone-9d91a',
        storageBucket: 'instagram-clone-9d91a.appspot.com',
      ),
    );
  } else {
    //This initializes the Firebase SDK for mobile. We need to await this as it takes time to initialize.
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase
      .initializeApp(); //Gives white screen if used without the above line.
  runApp(const MyApp());
}

// This Stateless Widget simply returns the Starting App Screen
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
