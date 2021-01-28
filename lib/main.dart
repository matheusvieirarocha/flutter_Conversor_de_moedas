import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

const request =
    "https://api.hgbrasil.com/finance/quotations?format=json-cors&key=7606644d";

void main() async {
  runApp(MyApp());
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Conversor de Moedas",
      home: Home(),
      theme: ThemeData(hintColor: Colors.black, primaryColor: Colors.black),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _real = TextEditingController();
  TextEditingController _dolar = TextEditingController();
  TextEditingController _libra = TextEditingController();
  TextEditingController _yen = TextEditingController();
  TextEditingController _euro = TextEditingController();

  double dolar;
  double euro;
  double yen;
  double libra;

  void _realChanged(String text) {
    double real;
    if (text.isNotEmpty) {
      real = double.parse(text);
    } else {
      real = 0;
    }

    _dolar.text = (real / dolar).toStringAsFixed(2);
    _euro.text = (real / euro).toStringAsFixed(2);
    _libra.text = (real / libra).toStringAsFixed(2);
    _yen.text = (real / yen).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text != null) {
      double dolar;
      if (text.isNotEmpty) {
        dolar = double.parse(text);
      } else {
        dolar = 0;
      }

      _real.text = (dolar * this.dolar).toStringAsFixed(2);
      _euro.text = (dolar * this.dolar / euro).toStringAsFixed(2);
      _libra.text = (dolar * this.dolar / libra).toStringAsFixed(2);
      _yen.text = (dolar * this.dolar / yen).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text) {
    double euro;
    if (text.isNotEmpty) {
      euro = double.parse(text);
    } else {
      euro = 0;
    }

    _dolar.text = (euro * this.euro / dolar).toStringAsFixed(2);
    _real.text = (euro * this.euro).toStringAsFixed(2);
    _libra.text = (euro * this.euro / libra).toStringAsFixed(2);
    _yen.text = (euro * this.euro / yen).toStringAsFixed(2);
  }

  void _libraChanged(String text) {
    double libra;
    if (text.isNotEmpty) {
      libra = double.parse(text);
    } else {
      libra = 0;
    }

    _dolar.text = (this.libra * libra / dolar).toStringAsFixed(2);
    _euro.text = (this.libra * libra / euro).toStringAsFixed(2);
    _real.text = (this.libra * libra).toStringAsFixed(2);
    _yen.text = (this.libra * libra / yen).toStringAsFixed(2);
  }

  void _yenChanged(String text) {
    double yen;
    if (text.isNotEmpty) {
      yen = double.parse(text);
    } else {
      yen = 0;
    }

    _dolar.text = (this.yen * yen / dolar).toStringAsFixed(2);
    _euro.text = (this.yen * yen / euro).toStringAsFixed(2);
    _libra.text = (this.yen * yen / libra).toStringAsFixed(2);
    _real.text = (this.yen * yen).toStringAsFixed(2);
  }

  void resetFields(){
    _dolar.text = "";
    _real.text = "";
    _yen.text = "";
    _libra.text="";
    _euro.text="";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Conversor de Moedas",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed:(){resetFields();})
          ],
        ),

        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando Dados...",
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                          textAlign: TextAlign.center));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Erro ao carregar dados",
                            style: TextStyle(color: Colors.amber, fontSize: 25),
                            textAlign: TextAlign.center));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    libra =
                        snapshot.data["results"]["currencies"]["GBP"]["buy"];
                    yen = snapshot.data["results"]["currencies"]["JPY"]["buy"];

                    return Form(
                        key: _formkey,
                        child: SingleChildScrollView(
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: Column(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 20),
                                      child: Icon(
                                        Icons.monetization_on,
                                        color: Colors.amber,
                                        size: 100,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: TextFormField(
                                      controller: _real,
                                      onChanged: _realChanged,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: "Real (BRL)",
                                          border: OutlineInputBorder(),
                                          prefixText: "R\$: ",
                                          labelStyle: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 25)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: TextFormField(
                                      controller: _dolar,
                                      onChanged: _dolarChanged,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          prefixText: "\$: ",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: "Dólar (USD)",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 25)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: TextFormField(
                                      controller: _euro,
                                      onChanged: _euroChanged,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          prefixText: "€: ",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: "Euro (EUR)",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 25)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: TextFormField(
                                      controller: _libra,
                                      onChanged: _libraChanged,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          prefixText: "£: ",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: "Libra Esterlina  (GBP)",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 25)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: TextFormField(
                                      controller: _yen,
                                      onChanged: _yenChanged,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          prefixText: "¥: ",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: "Yen (JPY)",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 25)),
                                    ),
                                  ),
                                ],
                              )),
                        ));
                  }
              }
            }));
  }
}
