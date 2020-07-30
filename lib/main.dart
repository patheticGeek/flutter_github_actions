import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter firebase',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  void initState() {
    super.initState();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value.text.trim(),
        password: password.value.text.trim(),
      );
    } catch (e) {
      print(e);
    }
  }

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.text.trim(),
        password: password.value.text.trim(),
      );
      // setState(() {
      //   currentUser = authResult.user;
      // });
    } catch (e) {
      print(e);
    }
  }

  Widget buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: _loginFormKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: email,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: signIn,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                  FlatButton(
                    onPressed: signUp,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.purple,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHomeScreen(FirebaseUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (user.photoUrl != null) Image.network(user.photoUrl),
        Text('${user.uid}'),
        Text('${user.displayName} (${user.email})'),
        FlatButton(
          onPressed: signOut,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        alignment: Alignment.center,
        child: StreamBuilder<FirebaseUser>(
          stream: _auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              FirebaseUser user = snapshot.data;
              return user == null ? buildLoginForm() : buildHomeScreen(user);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
