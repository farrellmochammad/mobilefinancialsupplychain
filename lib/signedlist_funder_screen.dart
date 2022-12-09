import 'package:flutter/material.dart';
import 'dart:convert';
import 'farmer_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Component/appbar.dart';
import 'farmer_update.dart';
import 'const/const.dart';



final storage = const FlutterSecureStorage();

class SignedListFunder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignedListViewFunder(),
      ),
    );
  }
}

class SignedListViewFunder extends StatelessWidget {

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
                                ViewSigned(
                                    fundid: snapshot.data[index]['fund_id']),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else {
            return Center(child: Text("Belum ada data petani yang di tanda tangan"));
          }
        },
      ),
    );
  }
}

class ViewSigned extends StatelessWidget {
  const ViewSigned({super.key, required this.fundid});

  final String fundid;

  Future<String> _fetchImageUrl() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(Uri.parse(url_api + '/sign/' + this.fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
    if (result.statusCode != 200) {
      return "";
    } else {
      return json.decode(result.body)['data']['sign_url'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.CreateAppBar("Sign Image"),
        body: Container (
          child: FutureBuilder<String>(
              future: _fetchImageUrl(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData){
                  if (snapshot.data!.isEmpty){
                    return Center(child: Text("Cannot render Image"));
                  }

                  if (snapshot.data!.isNotEmpty){
                    return Image.network(snapshot.data.toString());
                  }
                }

                return Center(child: Text("Canot Render Image"));
              },
          ),
        ),
      );
  }
}