import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:oauth2/oauth2.dart' as oath2;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => const LoginIdleState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('error: $error $stacktrace');
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginRequestEvent) {
      final authorizationEndpoint =
          Uri.parse('https://auth.domain.com.au/v1/connect/token');

      final client = await oath2.clientCredentialsGrant(
          authorizationEndpoint, event.client, event.secret,
          scopes: ['api_agencies_read', 'api_listings_read']);

      yield LoginSuccessState(client);
    }
  }
}

abstract class LoginEvent {}

class LoginRequestEvent implements LoginEvent {
  final String client, secret;

  LoginRequestEvent({this.client, this.secret});
}

abstract class LoginState {}

class LoginIdleState implements LoginState {
  const LoginIdleState();
}

class LoginSuccessState implements LoginState {
  final oath2.Client client;

  LoginSuccessState(this.client);
}
