import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'appbar.dart';
import '../const/const.dart';


final storage = const FlutterSecureStorage();


class TracingMonitoringView extends StatelessWidget {
  const TracingMonitoringView(
  {super.key,
  required this.fundid});

  final String fundid;

  Future<List<dynamic>> _fetchTracingMonitorings() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(Uri.parse(url_api + '/tracing_histories/' + fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
    return json.decode(result.body)['data']['monitorings'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: _fetchTracingMonitorings(),
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
                              "\nBerat : " +
                              snapshot.data[index]['Weight'].toString()),
                    ),
                  );
                });
          } else {
            return Center(child: Text('Belum ada data petani'));
          }
        },
      ),
    );
  }
}


class TracingTransactionView extends StatelessWidget {
  const TracingTransactionView(
      {super.key,
        required this.fundid});

  final String fundid;

  Future<List<dynamic>> _fetchTracingTransactions() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(Uri.parse(url_api + '/tracing_histories/' + fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
    return json.decode(result.body)['data']['transactions'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: _fetchTracingTransactions(),
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
                          "\nUsername : " +
                              snapshot.data[index]['Username'].toString() +
                          "\nStatus : " +
                          snapshot.data[index]['Status'].toString()),
                    ),
                  );
                });
          } else {
            return Center(child: Text('Belum ada data petani'));
          }
        },
      ),
    );
  }
}


class TracingPage extends StatelessWidget {
  // In the constructor, require a Todo.
  const TracingPage({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  Future<List<dynamic>> _fetchExperienceData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse(url_api + '/experiences_sales/' + this.fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBarComponent.CreateAppBar("Riwayat proses pengajuan dana" ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
              Flexible(
                child: TracingTransactionView(fundid: this.fundid),
              ),
              Flexible(
                  child: TracingMonitoringView(fundid: this.fundid),
              ),
            ]),
      ),
    );
  }
}