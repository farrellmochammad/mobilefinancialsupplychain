import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Component/dialog.dart';
import 'const/const.dart';
import 'Component/appbar.dart';


final storage = const FlutterSecureStorage();

class MonitoringFunderScreen extends StatelessWidget {

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
        Uri.parse(url_api + '/funders_approvefunder'),
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
                      title: Text("Fund Id : " + snapshot.data[index]['fund_id']),
                      subtitle: Text(
                              "Nik : " + snapshot.data[index]['nik'] +
                              "\nJumlah Kolam : " + snapshot.data[index]['number_of_ponds'].toString() +
                              "\nJumlah Pendanaan : Rp " + snapshot.data[index]['amount_of_fund'].toString() +
                              "\nTipe Ikan : " + snapshot.data[index]['fish_type']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MonitoringDetailScreen(fundid:  snapshot.data[index]['fund_id']),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else {
            return Center(child: Text("Belum ada data petani yang di monitoring"));
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

  Future<List<dynamic>> _fetchFunderData() async {
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
      appBar: AppBarComponent.CreateAppBar("Detil data pengajuan modal"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: FutureBuilder<List<dynamic>>(
            future: _fetchFunderData(),
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
                              if (!snapshot.data[index]['status'].toString().contains('Rejected')){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MonitoringDetailScreen(fundid:  snapshot.data[index]['fund_id']),
                                  ),
                                );
                              }
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

class MonitoringDetailScreen extends StatefulWidget {
  // In the constructor, require a Todo.
  const MonitoringDetailScreen({super.key, required this.fundid});


  // Declare a field that holds the Todo.
  final String fundid;

  @override
  State<MonitoringDetailScreen> createState() {
    // TODO: implement createState
    return _DetailMonitoringScreen();
  }
}

class _DetailMonitoringScreen extends State<MonitoringDetailScreen> {
  Future<List<dynamic>>? _futureResponse;


  @override
  void initState() {
    super.initState();
    _futureResponse = _fetchMonitoringData();
  }

  Future<List<dynamic>> _fetchMonitoringData() async {
    var token = await storage.read(key: 'token');

    var result = await http.get(
        Uri.parse(url_api + '/monitoring_pond/' + widget.fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        }
    );
    return json.decode(result.body)['data'];
  }

  FutureOr onGoBack(dynamic value) {
    _futureResponse = _fetchMonitoringData();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBarComponent.CreateAppBar("Daftar monitor panen"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: FutureBuilder<List<dynamic>>(
            future: _fetchMonitoringData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(),
                          subtitle: Text(
                                  "Tanggal : " + snapshot.data[index]['Timestamp'] +
                                  "\nBerat : " + snapshot.data[index]['Weight'].toString()),
                        ),
                      );
                    });
              } else {
                return Center(child: Text("Belum ada data monitor panen"));
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