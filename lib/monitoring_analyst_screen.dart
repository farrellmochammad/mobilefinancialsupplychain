import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Component/dialog.dart';
import 'Component/appbar.dart';
import 'const/const.dart';
import 'Component/tracing_component.dart';


final storage = const FlutterSecureStorage();

class MonitoringAnalystScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MonitoringList(),
      ),
    );
  }
}

class MonitoringList extends StatelessWidget {

  Future<List<dynamic>> _fetchFundersData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse(url_api + '/funders_analyst'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        }
    );
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: _fetchFundersData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: FlutterLogo(),
                      title: Text("Nik : " + snapshot.data[index]['nik']),
                      subtitle: Text("Jumlah Kolam : " + snapshot
                          .data[index]['number_of_ponds'].toString() +
                          " \nJumlah Pendanaan : Rp " + snapshot
                          .data[index]['amount_of_fund'].toString() +
                          " \nTipe Ikan : " +
                          snapshot.data[index]['fish_type']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FunderDetailScreen(
                                    nik: snapshot.data[index]['nik']),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else {
            return Center(child: Text("Belum ada data petani yang di funding"));
          }
        },
      ),
    );
  }
}


class FunderDetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const FunderDetailScreen({super.key, required this.nik});

  // Declare a field that holds the Todo.
  final String nik;

  Future<List<dynamic>> _fecthFunderData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse(url_api + '/funder_nik/' + this.nik),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        }
    );
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBarComponent.CreateAppBar("Details funder "),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: FutureBuilder<List<dynamic>>(
            future: _fecthFunderData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                            title: Text('Nik : ' + this.nik),
                            subtitle: Text("Disubmit oleh : " +
                                snapshot.data[index]['submitted_by'] +
                                "\nWaktu submit : " +
                                snapshot.data[index]['submitted_timestamp'] +
                                "\nJenis Ikan : " +
                                snapshot.data[index]['fish_type'].toString() +
                                "\nStatus : " +
                                snapshot.data[index]['status'] +
                                "\nJumlah Kolam : " +
                                snapshot.data[index]['number_of_ponds']
                                    .toString() +
                                "\nJumlah Pendanaan : " +
                                snapshot.data[index]['amount_of_fund']
                                    .toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TracingPage(
                                          fundid:  snapshot.data[index]['fund_id']),
                                ),
                              );
                            }
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}



class Response {
  final String status;

  Response({required this.status});

  String getResponseStatus() {
    return this.status;
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
    );
  }
}