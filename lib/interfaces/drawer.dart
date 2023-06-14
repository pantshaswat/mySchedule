import 'package:flutter/material.dart';

class drawerPage extends StatefulWidget {
  const drawerPage({super.key});

  @override
  State<drawerPage> createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Name"),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 53, 36, 103),
              Color.fromARGB(255, 51, 124, 234),
            ])),
            accountEmail: Text("Email"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Personal Information'),
            onTap: () {
              Navigator.pop(context);

              // Implement your personal information logic here
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pop(context);

              // Implement your change password logic here
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const ListTile(
            leading: Icon(Icons.attach_money_rounded),
            title: Text('Fare Calculator'),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
          const ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('Help'),
          ),
          const SizedBox(
            height: 10,
          ),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
