import 'package:flutter/material.dart';
import 'package:supplychainmobile/Networking/Album.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ApproverList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyStatelessWidget(),
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
    var result = await http.get(Uri.parse(apiUrl));
    print(json.decode(result.body)['data']);
    return json.decode(result.body)['data'];
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
