import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    String name = '';
    String email = '';
    if (user != null) {
        name = user.displayName ?? '';
        email = user.email ?? '';
    }

    void _submit() {
      auth.signOut();
    }

    return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(body: Center(child: 
        
        Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text('Profile', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text(name),
                  const SizedBox(height: 20),
                  Text(email),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Logout'),
                  ),

                ]
              )
        )
        
        )));
  }
}