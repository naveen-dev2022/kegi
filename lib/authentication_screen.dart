import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/language_screen.dart';
import 'package:kegi_sudo/screens/mainscreen.dart';
import 'package:kegi_sudo/utils/fullscreen_loader.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_state.dart';

class AuthenticationScreen extends StatelessWidget {
   AuthenticationScreen({Key? key,this.repository}) : super(key: key);
  Repository? repository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        if (state is AuthenticationSuccess) {
          return   const MainScreen();
        }
        if (state is AuthenticationFailure) {
          return  LanguageScreen(repository: repository);const MainScreen();
        }
        if (state is AuthenticationInProgress) {
          return FullScreenLoader();
        }
        return  LanguageScreen(repository: repository);const MainScreen();
      },
    );
  }
}
