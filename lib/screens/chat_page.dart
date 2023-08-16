// ignore_for_file: must_be_immutable
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constant/colors.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/chat_cubit/chat_state.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required});
  static String id = "chatPage";

  TextEditingController controller = TextEditingController();

  final _scrollController = ScrollController();
  List<Message> messagesList = [];
  @override
  Widget build(BuildContext context) {
    dynamic email = ModalRoute.of(context)!.settings.arguments;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                "assets/images/scholar.png",
                height: 50,
              ),
              const Text("Chat"),
            ]),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: BlocProvider.of<ChatCubit>(context)
                          .messagesList
                          .length,
                      itemBuilder: (context, index) {
                        return BlocProvider.of<ChatCubit>(context)
                                    .messagesList[index]
                                    .id ==
                                email
                            ? ChatBubble(
                                message: BlocProvider.of<ChatCubit>(context)
                                    .messagesList[index],
                              )
                            : ChatBubbleForFriend(
                                message: BlocProvider.of<ChatCubit>(context)
                                    .messagesList[index],
                              );
                      },
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
                      BlocProvider.of<ChatCubit>(context)
                          .sendMessage(message: data, email: email);
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
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
