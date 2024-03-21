import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebaseapp/pages/chat/chat_page.dart';
import 'package:firebaseapp/pages/tarefa_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var nickNameController = TextEditingController();
    final remoteConfig = FirebaseRemoteConfig.instance;
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Tarefas"),
            leading: const Icon(Icons.task),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TarefaPage()));
            },
          ),
          ListTile(
            title: const Text("Chat"),
            leading: const Icon(Icons.chat),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Informe seu apelido"),
                          TextField(
                            controller: nickNameController,
                          ),
                          TextButton(
                              child: Text(remoteConfig.getString("TEXTO_CHAT")),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ChatPage(
                                            nickName:
                                                nickNameController.text)));
                                nickNameController.text = "";
                              }),
                        ],
                      ),
                    );
                  });
            },
          ),
          ListTile(
            title: const Text("Bug"),
            leading: const Icon(Icons.bug_report),
            onTap: () {
              TextButton(
                onPressed: () => throw Exception(),
                child: const Text("Throw Test Exception"),
              );
            },
          ),
        ],
      ),
    );
  }
}
