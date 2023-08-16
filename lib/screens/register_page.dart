// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:chat_app/constant/colors.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/cubits/register_cubit/register_cubit_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/login_btn.dart';
import '../components/login_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'cubits/register_cubit/register_cubit_state.dart';

class RegisterPage extends StatelessWidget {
  String? email;

  String? password;

  bool isLoading = false;
  static String id = "registerPage";
  GlobalKey<FormState> formKey = GlobalKey();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
      if (state is RegisterLoading) {
        isLoading = true;
      } else if (state is RegisterSuccess) {
        Navigator.pushNamed(context, ChatPage.id);
        isLoading = false;
      } else if (state is RegisterFailure) {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.errMessage),
        ));
      }
    }, builder: (context, state) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  Image.asset(
                    "assets/images/scholar.png",
                    height: 100,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Scholar Chat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: "Pacifico",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  LoginTextField(
                    isObscureText: false,
                    hint: 'Email',
                    onChanged: (data) {
                      email = data;
                    },
                  ),
                  LoginTextField(
                    isObscureText: true,
                    hint: 'Password',
                    onChanged: (data) {
                      password = data;
                    },
                  ),
                  LoginBtn(
                    text: "Register",
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<RegisterCubit>(context)
                            .registerUser(email: email!, password: password!);
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          " Sign In",
                          style: TextStyle(
                            color: Color(0xFFC7EDE6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
