import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebaseapp/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Color(int.parse("0xff${remoteConfig.getString("COR_FUNDO_TELA")}")),
        drawer: const CustomDrawer(),
        appBar: AppBar(title: const Text("Firebase")),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}
