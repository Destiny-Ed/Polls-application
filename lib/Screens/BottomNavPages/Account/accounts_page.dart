import 'package:flutter/material.dart';
import 'package:my_polls/Providers/authentication_provider.dart';
import 'package:my_polls/Screens/Authentication/auth_page.dart';
import 'package:my_polls/Screens/main_activity_page.dart';
import 'package:my_polls/Screens/splash_screen.dart';
import 'package:my_polls/Styles/colors.dart';
import 'package:my_polls/Utils/message.dart';
import 'package:my_polls/Utils/router.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            AuthProvider().logOut().then((value) {
              // if (value == false) {
              //   error(context, message: "Please try again");
              // } else {
              nextPageOnly(context, const SplashScreen());
              // }
            });
          },
          child: Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Text("Log Out"),
          ),
        ),
      ),
    );
  }
}
