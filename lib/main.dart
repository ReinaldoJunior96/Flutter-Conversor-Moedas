import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=fead6306";

void main() async{
  print (await getData());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.white
    ),
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
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar;
  double euro;

  void _mudarReal(String text){
    double real = double.parse(text);
    dolarController.text = (real*dolar).toStringAsFixed(2);
    euroController.text = (real*dolar). toStringAsFixed(2);
  }
  void _mudarDolar(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _mudarEuro(String text){
    double euro = double.parse(text);
    realController.text= (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
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
                textAlign: TextAlign.center ),
              );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar =/",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0),
                    textAlign: TextAlign.center ),
                  );
                }else{
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 100.0, color: Colors.white),
                        buildTextField("Real", "RS", realController, _mudarReal),
                        Divider(),
                        buildTextField("Dolar", "US",dolarController, _mudarDolar),
                        Divider(),
                        buildTextField("Euro", "E", euroController, _mudarEuro),
                      ],
                    ),
                  );
                }
          }
        })
      );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
   style: TextStyle(
    color: Colors.white
   ),
   onChanged: f,
   keyboardType: TextInputType.number,
  );
}