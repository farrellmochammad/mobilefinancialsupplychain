import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();

class ApproverList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ApproverListView(),
      ),
    );
  }
}

class ApprovalItem extends StatelessWidget {
  const ApprovalItem({
    super.key,
    required this.approverid,
    required this.pondid,
    required this.nik,
    required this.status,
  });

  final String approverid;
  final String pondid;
  final String nik;
  final String status;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _ApprovalItem(
              approverid: approverid,
              pondid: pondid,
              nik: nik,
              status: status,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class _ApprovalItem extends StatelessWidget {
  const _ApprovalItem({
    required this.approverid,
    required this.pondid,
    required this.nik,
    required this.status,
  });

  final String approverid;
  final String pondid;
  final String nik;
  final String status;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            approverid,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            pondid,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            nik,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            status,
            style: const TextStyle(fontSize: 10.0),
          )

        ],
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  final String apiUrl = 'https://reqres.in/api/users?per_page=15';

  Future<List<dynamic>> _fetchDataUsers() async {
    var token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('http://localhost:2021/experience'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      }
    );

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    _fetchDataUsers();
    return ListView(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 106.0,
      children: <ApprovalItem>[
        ApprovalItem(
            approverid: "1235",
            pondid: "1",
            nik: "12341515",
            status: "Approved",
        ),
        ApprovalItem(
          approverid: "1235",
          pondid: "1",
          nik: "12341515",
          status: "Approved",
        ),
      ],
    );
  }
}

class ApproverListView extends StatelessWidget {

  Future<List<dynamic>> _fecthExperiencesData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/experiences'),
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
          future: _fecthExperiencesData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: FlutterLogo(),
                        title: Text('Nik : ' + snapshot.data[index]['nik']),
                        subtitle: Text("Nama : " + snapshot.data[index]['name'] + " \nAlamat : " + snapshot.data[index]['address'] + "\nStatus : " + snapshot.data[index]['current_status']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(nik: snapshot.data[index]['nik'], address: snapshot.data[index]['address']),
                            ),
                          );
                        },
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

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.nik, required this.address});

  // Declare a field that holds the Todo.
  final String nik;
  final String address;

  Future<List<dynamic>> _fecthExperienceData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/experience/' + this.nik),
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
        title: Text("Details of " + nik),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: FutureBuilder<List<dynamic>>(
            future: _fecthExperienceData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text('Nik : ' + this.nik),
                          subtitle: Text("Di submit oleh : " + snapshot.data[index]['Submitby'] + "\nStatus : " + snapshot.data[index]['Status'] + " \nTanggal : " + snapshot.data[index]['Timestamp'] + "\nJumlah Kolam : " + snapshot.data[index]['Numofponds'].toString() + "\nRerata panen : " + snapshot.data[index]['Spawningaverage'].toString() + "\nSkor Kredit : " + snapshot.data[index]['Creditscore'].toString()),
                        ),
                      );
                    });
              } else {
                return Center(child: Text(''));
              }
            },
          ),
        ),
      ),
    );
  }
}