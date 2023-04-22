import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'auth.dart';
import 'profile.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);

  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Visibility(
                  visible: constraints.maxWidth >= 1200,
                  child: Expanded(
                    child: Container(
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Eagle Eats',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth >= 1200
                      ? constraints.maxWidth / 2
                      : constraints.maxWidth,
                  child: StreamBuilder<User?>(
                    stream: auth.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Profile();
                      }
                      return const AuthGate();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
