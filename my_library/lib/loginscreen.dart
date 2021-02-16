import 'package:flutter/material.dart';
import 'package:my_library/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'mainscreen.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passEditingController = new TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

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
                          controller: emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        Text("Password"),
                        TextField(
                          controller: passEditingController,
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

  void _onLogin() {
    String email = emailEditingController.text.toString();
    String pass = passEditingController.text.toString();
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    pr.show();
    http.post("https://slumberjer.com/mylibrary/php/loginuser.php", body: {
      "email": email,
      "password": pass,
    }).then((res) {
      List userdata = res.body.split(",");
      pr.hide();
      if (userdata[0] == "success") {
       
        User user = new User(email: email,nickname: userdata[1],password: pass);

        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(user: user)));

      } else {
        Toast.show(
          "Login Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
      
    }).catchError((err) {
      print(err);
    });
  }

  void _onChange(bool value) {
    String email = emailEditingController.text.toString();
    String pass = passEditingController.text.toString();
    if (!(email.isEmpty && pass.isEmpty)) {
      setState(() {
        _rememberMe = value;
      });
      savepref(value);
    } else {
      Toast.show(
        "Please fill in required information",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    String email = emailEditingController.text.toString();
    String pass = passEditingController.text.toString();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('password', pass);
      await prefs.setBool('rememberme', value);
      Toast.show(
        "Preferences saved",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    } else {
      await prefs.setString('email', "");
      await prefs.setString('password', "");
      await prefs.setBool('rememberme', false);
      Toast.show(
        "Preferences removed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      String _email = (prefs.getString('email')) ?? '';
      String _password = (prefs.getString('password')) ?? '';
      emailEditingController.text = _email;
      passEditingController.text = _password;
      _rememberMe = (prefs.getBool('rememberme')) ?? false;
    });
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }
}
