import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'book.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class UpdateBookScreen extends StatefulWidget {
  final Book book;

  const UpdateBookScreen({Key key, this.book}) : super(key: key);

  @override
  _UpdateBookScreenState createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/uum.png";
  List<String> listType = [
    "Novel",
    "Education",
    "Fiction",
    "Magazine",
    "Other",
  ];
  String selectedType;
  TextEditingController booktitlectrl = new TextEditingController();
  TextEditingController bookdescctrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    booktitlectrl.text = widget.book.title;
    bookdescctrl.text = widget.book.description;
    selectedType = widget.book.type;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        title: 'My Library',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Edit Book'),
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
                      controller: booktitlectrl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Book Title', icon: Icon(Icons.book))),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.grey),
                      SizedBox(width: 15),
                      DropdownButton(
                        hint: Text(
                          'Book Type',
                          style: TextStyle(
                            color: Color.fromRGBO(253, 72, 13, 50),
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedType = newValue;
                            print(selectedType);
                          });
                        },
                        value: selectedType,
                        items: listType.map((selectedType) {
                          return DropdownMenuItem(
                            child: new Text(
                              selectedType,
                            ),
                            value: selectedType,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextField(
                      controller: bookdescctrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Book Description',
                          icon: Icon(Icons.notes))),
                  SizedBox(height: 15),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: screenWidth / 1.2,
                    height: 50,
                    child: Text('Update Book'),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    elevation: 15,
                    onPressed: _updateBookDialog,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _updateBookDialog() {
    String booktitle = booktitlectrl.text.toString();
    String bookdesc = bookdescctrl.text.toString();
    print(selectedType);
    if (booktitle.isEmpty || bookdesc.isEmpty) {
      Toast.show(
        "Please enter your book title and description",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }
    if (selectedType == null) {
      Toast.show(
        "Please select book type",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Update this book?",
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
                updateBook(booktitle, bookdesc);
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

  void updateBook(String booktitle, String bookdesc) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post("https://slumberjer.com/mylibrary/php/updatebook.php", body: {
      "bookid": widget.book.bookid,
      "booktitle": booktitle,
      "booktype": selectedType,
      "bookdesc": bookdesc,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show(
          "Update Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Update Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _onPictureSelection() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
