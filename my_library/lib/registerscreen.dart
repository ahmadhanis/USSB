import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nickTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passTextEditingController = new TextEditingController();
  TextEditingController pass2TextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Library',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
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
                      Text("Nick Name"),
                      TextField(
                        controller: nickTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      Text("Email"),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      Text("Password"),
                      TextField(
                        controller: passTextEditingController,
                        obscureText: true,
                      ),
                      SizedBox(height: 15),
                      Text("Reenter Password"),
                      TextField(
                        controller: pass2TextEditingController,
                        obscureText: true,
                      ),
                      SizedBox(height: 15),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Register'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onRegister,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                          onTap: _toLoginScreen,
                          child: Text("Already register?"))
                    ],
                  )),
            ],
          ),
        )),
      ),
    );
  }

  void _onRegister() {
    String nickname = nickTextEditingController.text.toString();
    String email = emailTextEditingController.text.toString();
    String pass1 = passTextEditingController.text.toString();
    String pass2 = pass2TextEditingController.text.toString();
    if (nickname.isEmpty || email.isEmpty || pass1.isEmpty || pass2.isEmpty) {
      Toast.show(
        "Please fill in registration information",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }
    if (!validateEmail(email)) {
      Toast.show(
        "Please Check your email",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }
    if (pass1 != pass2) {
      Toast.show(
        "Please Check your password",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }
    //confirmation dialog...
    _confirmDialog(nickname, email, pass1);
  }

  registerUser(String nickname, String email, String pass1) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    pr.show();
    http.post("https://slumberjer.com/mylibrary/php/registeruser.php", body: {
      "nickname": nickname,
      "email": email,
      "password": pass1,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show(
          "Registration Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Registration Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  void _toLoginScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  _confirmDialog(String nickname, String email, String pass1) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new account?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                registerUser(nickname, email, pass1);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
