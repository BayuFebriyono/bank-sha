import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../shared/shared_method.dart';
import '../../shared/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/forms.dart';

class ProfileEditPinPage extends StatefulWidget {
  const ProfileEditPinPage({super.key});

  @override
  State<ProfileEditPinPage> createState() => _ProfileEditPinPageState();
}

class _ProfileEditPinPageState extends State<ProfileEditPinPage> {
  final oldPinController = TextEditingController(text: '');
  final newPinController = TextEditingController(text: '');

  bool validate() {
    if (oldPinController.text.length != 6 ||
        newPinController.text.length != 6) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit PIN',
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            showCustomSnackbar(context, state.e);
          }
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/profile-edit-success', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            children: [
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
                    CustomFormField(
                      title: 'Old PIN',
                      controller: oldPinController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      title: 'New Pin',
                      controller: newPinController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: [
                        CustomFilledButton(
                          title: 'Update Now',
                          onPressed: () {
                            if (validate()) {
                              context.read<AuthBloc>().add(
                                    AuthUpdatePin(oldPinController.text,
                                        newPinController.text),
                                  );
                            }else{
                              showCustomSnackbar(context, 'Panjang pin harus 6 digit');
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
