import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/models/tarefa_models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TarefaPage extends StatefulWidget {
  const TarefaPage({super.key});

  @override
  State<TarefaPage> createState() => _TarefaPageState();
}

class _TarefaPageState extends State<TarefaPage> {
  final descricaoContoller = TextEditingController();
  final db = FirebaseFirestore.instance;
  var apenasNaoConcluidos = false;
  String userId = "";

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tarefas Firebase"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            descricaoContoller.text = "";
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    title: const Text("Adicionar tarefa"),
                    content: TextField(
                      controller: descricaoContoller,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () async {
                            var tarefa = TarefaModel(
                                descricao: descricaoContoller.text,
                                concluido: false,
                                userId: userId);
                            await db.collection("tarefas").add(tarefa.toJson());
                            // Navigator.pop(context);
                          },
                          child: const Text("Salvar"))
                    ],
                  );
                });
          },
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Apenas não concluídos",
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                      value: apenasNaoConcluidos,
                      onChanged: (bool value) {
                        apenasNaoConcluidos = value;
                        setState(() {});
                      })
                ],
              ),
            ),
            // carregando
            //     ? const CircularProgressIndicator()
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: apenasNaoConcluidos
                        ? db
                            .collection("tarefas")
                            .where('concluido', isEqualTo: false)
                            .where('user_id', isEqualTo: userId)
                            .snapshots()
                        : db
                            .collection("tarefas")
                            .where('user_id', isEqualTo: userId)
                            .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? const CircularProgressIndicator()
                          : ListView(
                              children: snapshot.data!.docs.map((e) {
                              var tarefa = TarefaModel.fromJson(
                                  (e.data() as Map<String, dynamic>));
                              return Dismissible(
                                onDismissed:
                                    (DismissDirection dismissDirection) async {
                                  await db
                                      .collection("tarefas")
                                      .doc(e.id)
                                      .delete();
                                },
                                key: Key(e.id),
                                child: ListTile(
                                    title: Text(tarefa.descricao),
                                    trailing: Switch(
                                        onChanged: (bool value) async {
                                          tarefa.concluido = value;
                                          tarefa.dataAlteracao = DateTime.now();
                                          await db
                                              .collection("tarefas")
                                              .doc(e.id)
                                              .update(tarefa.toJson());
                                        },
                                        value: tarefa.concluido)),
                              );
                            }).toList());
                    }))
          ]),
        ));
  }
}
