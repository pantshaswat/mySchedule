import 'package:flutter/material.dart';

import '../components/textfield.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool isPassShown = true;
  IconData? passIcon() {
    if (isPassShown) {
      return Icons.remove_red_eye;
    } else if (!isPassShown) {
      return Icons.no_adult_content;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: h,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      "assets/images/image.png",
                    ),
                  ),
                  const Text(
                    "Register!",
                    style: TextStyle(
                        fontFamily: 'mainFont',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  reusableTextField(
                    "Enter your First Name",
                    Icons.person_2_outlined,
                    false,
                    emailController,
                  ),

                  const SizedBox(height: 8),
                  reusableTextField(
                    "Enter your Last Name",
                    Icons.person_2_outlined,
                    false,
                    emailController,
                  ),

                  const SizedBox(height: 8),
                  reusableTextField(
                    "Enter your Email",
                    Icons.email,
                    false,
                    emailController,
                  ),
                  //pass
                  const SizedBox(height: 8),
                  reusableTextField("Enter your Password", Icons.lock_outline,
                      isPassShown, passwordController, suffixIcon: passIcon(),
                      onTap: () {
                    setState(() {
                      isPassShown = !isPassShown;
                    });
                  }),
                  const SizedBox(height: 8),
                  reusableTextField("Confirm your Password", Icons.lock_outline,
                      isPassShown, passwordController, suffixIcon: passIcon(),
                      onTap: () {
                    setState(() {
                      isPassShown = !isPassShown;
                    });
                  }),
                  const SizedBox(height: 15),
                  elevatedButtons(() {}, "Login", 50, w * 0.9),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      myDivider(),
                      const Text('Already a member?',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'mainFont',
                              color: Colors.white)),
                      myDivider(),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Login Now",
                              style: TextStyle(
                                fontFamily: 'mainFont',
                                color: Colors.white,
                              ))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
