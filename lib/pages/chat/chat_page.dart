import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/models/text_model.dart';
import 'package:firebaseapp/shared/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String nickName;
  const ChatPage({super.key, required this.nickName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final db = FirebaseFirestore.instance;
  final textController = TextEditingController(text: "");
  String userId = "";

  @override
  void initState() {
    carregarUsuario();
    super.initState();
  }

  carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db.collection("chats").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const CircularProgressIndicator()
                    : ListView(
                        children: snapshot.data!.docs.map((e) {
                          var textModel = TextModel.fromJson(
                              e.data() as Map<String, dynamic>);
                          return ChatWidget(
                              textModel: textModel,
                              myMessage: textModel.userId == userId);
                        }).toList(),
                      );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration:
                        const InputDecoration(focusedBorder: InputBorder.none),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      var textModel = TextModel(
                        dataHora: DateTime.now(),
                        nickname: widget.nickName,
                        text: textController.text,
                        userId: userId,
                      );
                      await db.collection("chats").add(textModel.toJson());
                      textController.text = "";
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
