import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocasa/src/views/blocs/login_bloc.dart';
import 'package:pocasa/src/views/blocs/listings_bloc.dart';
import 'package:pocasa/src/views/overview.dart';
import 'package:pocasa/src/views/property_listing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LoginBloc _loginBloc = LoginBloc();
  final ListingsBloc _listingsBloc = ListingsBloc();
  bool _initialized = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _initialized = true;

      print('BIG MAIN');
      _loginBloc.add(LoginRequestEvent(
          client: 'client_9f6a7473c9bbe0e568b5bddbf32d96a5',
          secret: 'secret_0baf5298064a7c5b639889e001c0558a'));
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
          buttonColor: Colors.pinkAccent),
      home: MyHomePage(
        title: 'Find your dream home!',
        loginBloc: _loginBloc,
        listingsBloc: _listingsBloc,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final LoginBloc loginBloc;
  final ListingsBloc listingsBloc;

  MyHomePage({Key key, this.title, this.loginBloc, this.listingsBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: BlocProvider(
          child: BlocProvider(
              child: PropertyListing(),
              create: (BuildContext context) => listingsBloc),
          create: (BuildContext context) => loginBloc),
    );
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
}
