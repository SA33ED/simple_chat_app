// ignore_for_file: unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:chat_app/screens/cubits/register_cubit/register_cubit_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterCubit extends Cubit<RegisterState> {
  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    } on FirebaseException catch (ex) {
      if (ex.code == 'week-password') {
        emit(RegisterFailure(errMessage: 'week-password'));
      } else if (ex.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'email-already-in-use'));
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: "somthing went wrong"));
    }
  }

  RegisterCubit() : super(RegisterInitial());
}
