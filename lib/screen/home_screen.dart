import 'package:flutter/material.dart';
import 'package:otp/provider/auth_provider.dart';
import 'package:otp/screen/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("การตรวจสอบสิทธิ์ FlutterPhone"),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: NetworkImage(ap.userModel.profilePic),
            radius: 50,
          ),
          const SizedBox(height: 20),
          Text(ap.userModel.name),
          Text(ap.userModel.phoneNumber),
          Text(ap.userModel.email),
          Text(ap.userModel.bio),
        ],
      )),
    );
  }
}
