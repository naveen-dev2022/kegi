import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kegi_sudo/myapp.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreference.getInstance();
  final Repository repository = Repository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) {
        return AuthenticationBloc(
          repository: repository,
        )..add(AuthenticationStarted());
      },
      child: MyApp(repository:repository),
    ),
  );
}