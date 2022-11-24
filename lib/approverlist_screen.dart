import 'package:flutter/material.dart';
import 'dart:convert';
import 'farmer_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Component/appbar.dart';
import 'farmer_update.dart';

final storage = const FlutterSecureStorage();

class ApproverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ApproverListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FarmerInput()));
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
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

class ApproverListView extends StatelessWidget {
  Future<List<dynamic>> _fecthExperiencesData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(Uri.parse('http://localhost:2021/experiences'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
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
                        subtitle: Text("Nama : " +
                            snapshot.data[index]['name'] +
                            " \nAlamat : " +
                            snapshot.data[index]['address'] +
                            "\nStatus : " +
                            snapshot.data[index]['current_status']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    nik: snapshot.data[index]['nik'],
                                    name: snapshot.data[index]['name'],
                                    phone: snapshot.data[index]['phone'],
                                    dob: snapshot.data[index]['dob'],
                                    address: snapshot.data[index]['address'],
                                    startfarming: snapshot.data[index]
                                        ['start_farming'],
                                    fishtype: snapshot.data[index]['fish_type'],
                                    numberofponds: snapshot.data[index]
                                            ['number_of_ponds']
                                        .toString(),
                                    notes: snapshot.data[index]['notes']),
                              ));
                        }),
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
  const DetailScreen(
      {super.key,
      required this.nik,
      required this.name,
      required this.phone,
      required this.dob,
      required this.address,
      required this.startfarming,
      required this.fishtype,
      required this.numberofponds,
      required this.notes});

  // Declare a field that holds the Todo.
  final String nik;
  final String name;
  final String phone;
  final String dob;
  final String address;
  final String startfarming;
  final String fishtype;
  final String numberofponds;
  final String notes;

  Future<List<dynamic>> _fecthExperienceData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/experiences_sales'),
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
      appBar: AppBarComponent.CreateAppBar("Details of " + nik),
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
                          subtitle: Text("Disubmit oleh : " +
                              snapshot.data[index]['submitted_by'] +
                              "\nWaktu submit : " +
                              snapshot.data[index]['submitted_timestamp'] +
                              "\nJenis Ikan : " +
                              snapshot.data[index]['fish_type'].toString() +
                              "\nJumlah Kolam : " +
                              snapshot.data[index]['number_of_ponds']
                                  .toString() +
                              "\nJumlah Pendanaan : " +
                              snapshot.data[index]['amount_of_fund']
                                  .toString()),
                        ),
                      );
                    });
              } else {
                return Center(child: Text('Belum ada data submit petani'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FarmerUpdate(
                nik: this.nik,
                name: this.name,
                phone: this.phone,
                dob: this.dob,
                address: this.address,
                startfarming: this.startfarming,
                fishtype: this.fishtype,
                numberofponds: this.numberofponds,
                notes: this.notes),
          ));
        },
        label: const Text('Update Data'),
        icon: const Icon(Icons.person_pin),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
