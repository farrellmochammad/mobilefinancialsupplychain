import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();

class MonitoringScreen extends StatelessWidget {

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

  Future<List<dynamic>> _fetchMonitoringsData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/monitorings'),
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
        future: _fetchMonitoringsData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: FlutterLogo(),
                      title: Text("Fund ID : " + snapshot.data[index]['fund_id']),
                      subtitle: Text("Nik : " + snapshot.data[index]['nik'] + "\nNama : " + snapshot.data[index]['name'] + " \nTotal Panen : " + snapshot.data[index]['total_spawning'].toString() + " kg\nTipe Ikan : " + snapshot.data[index]['fish_type']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(fundid: snapshot.data[index]['fund_id']),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  Future<List<dynamic>> _fetchPondData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/pond_fundid/' + this.fundid),
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
      appBar: AppBar(
        title: Text("Details of fundid " + fundid),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: FutureBuilder<List<dynamic>>(
            future: _fetchPondData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(),
                          title: Text("Pond ID : " + snapshot.data[index]['pond_id']),
                          subtitle: Text("Fund ID : " + snapshot.data[index]['fund_id'] + "\nTotal Panen : " + snapshot.data[index]['total_spawning'].toString() + " kg\nTipe Ikan : " + snapshot.data[index]['fish_type']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddMonitoring()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMonitoring extends StatelessWidget {
  const AddMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Pond Id"),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      );
  }
}