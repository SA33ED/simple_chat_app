// ignore_for_file: must_be_immutable

import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constant/collections.dart';
import 'package:chat_app/constant/colors.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required});
  static String id = "chatPage";

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  TextEditingController controller = TextEditingController();

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    dynamic email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: kPrimaryColor,
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    "assets/images/scholar.png",
                    height: 50,
                  ),
                  const Text("Chat"),
                ]),
                centerTitle: true,
              ),
              body: snapshot.hasData
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            itemCount: messagesList.length,
                            itemBuilder: (context, index) {
                              return messagesList[index].id == email
                                  ? ChatBubble(
                                      message: messagesList[index],
                                    )
                                  : ChatBubbleForFriend(
                                      message: messagesList[index],
                                    );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: controller,
                            onSubmitted: (data) {
                              if (data.isNotEmpty) {
                                messages.add({
                                  'messages': data,
                                  'createdAt': DateTime.now(),
                                  'id': email,
                                });
                                controller.clear();
                                if (_scrollController.hasClients) {
                                  _scrollController.animateTo(0,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                }
                              }
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.red,
                                hintText: "Send Message",
                                suffixIcon: const Icon(
                                  Icons.send,
                                  color: kPrimaryColor,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: kPrimaryColor),
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          ),
                        ),
                      ],
                    )
                  : ModalProgressHUD(
                      inAsyncCall: true,
                      progressIndicator:
                          const CircularProgressIndicator(color: kPrimaryColor),
                      child: Container(),
                    ),
            ),
          );
        } else {
          return ModalProgressHUD(
            inAsyncCall: true,
            progressIndicator:
                const CircularProgressIndicator(color: kPrimaryColor),
            child: Container(),
          );
        }
      },
    );
  }
}
