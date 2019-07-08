import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=fead6306";

void main() async{
  print (await getData());
  runApp(MaterialApp(
    home: Home()
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future:  getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 20.0),
                textAlign: TextAlign.center 
                ),
              );
          }
        })
      ),
  }
}