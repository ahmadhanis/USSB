import 'dart:io';
import 'package:flutter/material.dart';
import 'user.dart';

class NewBookScreen extends StatefulWidget {
  final User user;

  const NewBookScreen({Key key, this.user}) : super(key: key);
  @override
  _NewBookScreenState createState() => _NewBookScreenState();
}

class _NewBookScreenState extends State<NewBookScreen> {
  double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    File _image;
    String pathAsset = "assets/images/uum.png";

    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Material App Bar'),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () => {},
                      child: Container(
                        height: screenHeight / 3.2,
                        width: screenWidth / 1.8,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) //         <--- border radius here
                              ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
