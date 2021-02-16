import 'package:flutter/material.dart';
import 'package:my_library/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Library',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Center(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/uum.png",
                  scale: 3,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text("Email"),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        Text("Password"),
                        TextField(
                          obscureText: true,
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (bool value) {
                                _onChange(value);
                              },
                            ),
                            Text('Remember Me', style: TextStyle(fontSize: 16))
                          ],
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 300,
                          height: 50,
                          child: Text('Login'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onLogin,
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: _registerUser,
                            child: Text("Create New Account"))
                      ],
                    )),
              ],
            )),
          ),
        ));
  }

  void _onLogin() {}

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }
}
