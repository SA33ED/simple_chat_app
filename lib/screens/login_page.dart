// ignore_for_file: unused_local_variable, use_build_context_synchronously, must_be_immutable

import 'package:chat_app/components/login_btn.dart';
import 'package:chat_app/components/login_text_field.dart';
import 'package:chat_app/constant/colors.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  static String id = "loginPage";
  String? email;
  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
            ),
          );
        }
      },
      builder: (context, state) {
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
                          "Sign in",
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
                      text: "SIGN IN",
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<LoginCubit>(context)
                              .loginUser(email: email!, password: password!);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: const Text(
                            " Sign Up",
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
      },
    );
  }
}
