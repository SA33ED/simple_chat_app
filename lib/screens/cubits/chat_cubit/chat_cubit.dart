import 'package:bloc/bloc.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constant/collections.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList = [];
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  void sendMessage({
    required String message,
    required String email,
  }) {
    messages.add({
      'messages': message,
      'createdAt': DateTime.now(),
      'id': email,
    });
  }

  void getMessages() {
    messages.orderBy('createdAt', descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccsessState(messagesList: messagesList));
    });
  }
}
