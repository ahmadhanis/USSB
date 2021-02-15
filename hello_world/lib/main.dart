import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Text("Welcome to Flutter"),
                Text("Flutter is fun"),
                Row(children: [
                  Text("How Are you "),
                  Text("Razyn?")

                ],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}