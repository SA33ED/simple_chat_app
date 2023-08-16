import 'package:chat_app/models/message_model.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSuccsessState extends ChatState {
  List<Message> messagesList;
  ChatSuccsessState({required this.messagesList});
}
