import 'package:flutter/material.dart';
import 'package:myschedule/interfaces/registerPage.dart';

import '../components/textfield.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool isPassShown = true;
  IconData? passIcon() {
    if (isPassShown) {
      return Icons.remove_red_eye;
    } else if (!isPassShown) {
      return Icons.no_adult_content;
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                height: h,
                width: w,
                color: Colors.deepPurple,
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 120,
                      backgroundImage: AssetImage(
                        "assets/images/image.png",
                      ),
                    ),
                    Text(
                      "Welcome!",
                      style: TextStyle(
                          fontFamily: 'mainFont',
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    reusableTextField(
                      "Enter your Email",
                      Icons.person_2_outlined,
                      false,
                      emailController,
                    ),
                    //pass
                    const SizedBox(height: 10),
                    reusableTextField("Enter your Password", Icons.lock_outline,
                        isPassShown, passwordController, suffixIcon: passIcon(),
                        onTap: () {
                      setState(() {
                        isPassShown = !isPassShown;
                      });
                    }),

                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'mainFont'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    elevatedButtons(() {}, "Login", 50, w * 0.9),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        myDivider(),
                        const Text('Not a member?',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'mainFont',
                                color: Colors.white)),
                        myDivider(),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const registerPage(),
                            ));
                          },
                          child: const Text("Register Now",
                              style: TextStyle(
                                fontFamily: 'mainFont',
                                color: Colors.white,
                              ))),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
