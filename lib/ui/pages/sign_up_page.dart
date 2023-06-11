import 'package:bank_sha/shared/shared_method.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/sign_up_set_profile_page.dart';
import 'package:bank_sha/ui/widgets/buttons.dart';
import 'package:bank_sha/ui/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../models/sign_up_form_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  bool validate() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            showCustomSnackbar(context, state.e);
          }

          if (state is AuthCheckEmailSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpSetProfile(
                  data: SignUpFormModel(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Container(
                width: 155,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 100,
                  bottom: 100,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/img_logo_light.png',
                    ),
                  ),
                ),
              ),
              Text(
                'Join Us to Unlock\nYour Growth',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOTE INPUT NAME
                    CustomFormField(
                      title: 'Full Name',
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // NOTE INPUT EMAIL
                    CustomFormField(
                      title: 'Email Address',
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // NOTE INPUT PASS
                    CustomFormField(
                      title: 'Password',
                      obscureText: true,
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        CustomFilledButton(
                          title: 'Continue',
                          onPressed: () {
                            if (validate()) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthCheckEmail(emailController.text));
                            } else {
                              showCustomSnackbar(
                                  context, 'Semua field harus diisi');
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextButton(
                title: 'Sign In',
                onPressed: () {
                  Navigator.pushNamed(context, '/sign-in');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
