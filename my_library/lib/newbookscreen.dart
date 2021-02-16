import 'dart:io';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewBookScreen extends StatefulWidget {
  final User user;

  const NewBookScreen({Key key, this.user}) : super(key: key);
  @override
  _NewBookScreenState createState() => _NewBookScreenState();
}

class _NewBookScreenState extends State<NewBookScreen> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/uum.png";
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
                  Center(),
                  GestureDetector(
                      onTap: () => {_onPictureSelection()},
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
                  SizedBox(height: 5),
                  Text("Click image to take picture",
                      style: TextStyle(fontSize: 12.0, color: Colors.black)),
                  SizedBox(height: 5),
                  TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Book Title', icon: Icon(Icons.book))),
                  TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Book Description',
                          icon: Icon(Icons.notes))),
                  SizedBox(height: 15),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: screenWidth / 1.2,
                    height: 50,
                    child: Text('Insert New Book'),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    elevation: 15,
                    onPressed: _insertNewBookDialog,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _insertNewBookDialog() {}

  _onPictureSelection() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {});
  }
}
