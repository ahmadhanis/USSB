import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'book.dart';
import 'newbookscreen.dart';
import 'updatebookscreen.dart';
import 'user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List bookList;
  String titlecenter = "Loading...";
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'My Library',
      home: Scaffold(
        appBar: AppBar(
          title: Text('MainScreen'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        NewBookScreen(user: widget.user)));
            _loadBooks();
          },
        ),
        body: Center(
          child: Container(
              child: Column(
            children: [
              bookList == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))))
                  : Flexible(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 0.7,
                          children: List.generate(bookList.length, (index) {
                            return Padding(
                                padding: EdgeInsets.all(2),
                                child: Card(
                                    elevation: 10,
                                    child: InkWell(
                                        onTap: () => _updateBook(index),
                                        onLongPress: () => _deleteDialog(index),
                                        child: SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: screenHeight / 4.5,
                                                    width: screenWidth / 3,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://slumberjer.com/mylibrary/images/${bookList[index]['bookid']}.jpg",
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                        Icons.broken_image,
                                                        size: screenWidth / 2,
                                                      ),
                                                    )),
                                                Text(
                                                  bookList[index]['title'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  bookList[index]
                                                      ['description'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        )))));
                          })))
            ],
          )),
        ),
      ),
    );
  }

  void _loadBooks() {
    http.post("https://slumberjer.com/mylibrary/php/loadbooks.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookList = null;
        setState(() {
          titlecenter = "No Book Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          bookList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete " + bookList[index]['title'] + "?",
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
                _deleteBook(index);
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

  void _deleteBook(int index) {
    http.post("https://slumberjer.com/mylibrary/php/deletebook.php", body: {
      "bookid": bookList[index]['bookid'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        _loadBooks();
      } else {
        Toast.show(
          "Delete Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _updateBook(int index) async {
    String bookid = bookList[index]['bookid'];
    String description = bookList[index]['description'];
    String title = bookList[index]['title'];
    String type = bookList[index]['type'];

    Book book = new Book(
        bookid: bookid, description: description, title: title, type: type);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateBookScreen(book: book)));
    _loadBooks();
  }
}
