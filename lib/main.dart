import 'package:flutter/material.dart';
import 'package:test_app/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase auth issue',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final auth = Auth(currentLanguage: 'en');

  void _onTapLogin(){
    auth.signInWithEmailAndPassword('rebazrauf@gmail.com', 'rebaz12345678');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        initialData: AuthState.init,
        stream: auth.authState,
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Center(
              child: Text(snapshot.error?.toString()),
            );
          }else if (!snapshot.hasData){
            return const CircularProgressIndicator();
          }

          switch(snapshot.data){
            case AuthState.init:
              return Center(
                child: RaisedButton(
                  onPressed: _onTapLogin,
                  child: Text('Login with email(rebazrauf@gmail.com)'),
                ),
              );
            case AuthState.on_email_auth_success:
              return Center(
                child: Text('Success'),
              );
            case AuthState.loading:
              return Center(child: const CircularProgressIndicator());
            default:
              return Center(child: Text(snapshot.data.toString()));
          }
        },
      ),
    );
  }
}
