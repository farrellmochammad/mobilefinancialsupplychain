import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Pdfviewer_screen.dart';


final storage = const FlutterSecureStorage();

class ApproverListFunder extends StatelessWidget {

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
                              builder: (context) => DetailScreen(nik: snapshot.data[index]['nik'], address: snapshot.data[index]['address'], urlfile: snapshot.data[index]['url_file']),
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
  const DetailScreen({super.key, required this.nik, required this.address, required this.urlfile});

  // Declare a field that holds the Todo.
  final String nik;
  final String address;
  final String urlfile;

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
        title: Text("Details of bla bla " + nik),
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
                          leading: FlutterLogo(),
                          title: Text('Nik : ' + this.nik),
                          subtitle: Text("Di submit oleh : " + snapshot.data[index]['Submitby'] + "\nStatus : " + snapshot.data[index]['Status'] + " \nTanggal : " + snapshot.data[index]['Timestamp'] + "\nJumlah Kolam : " + snapshot.data[index]['Numofponds'].toString() + "\nRerata panen : " + snapshot.data[index]['Spawningaverage'].toString() + "\nSkor Kredit : " + snapshot.data[index]['Creditscore'].toString() + "\n\n Tekan untuk melihat file url"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewer(),
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
        ),

      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileInput()));
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        )
    );

  }
}

class FileInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Masukan jumlah pendanaan dalam (Rp)"),
      ),
      body: FileInputForm(),
    );
  }
}

// Create a Form widget.
class FileInputForm extends StatefulWidget {
  @override
  FileInputFormState createState() {
    return FileInputFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class FileInputFormState extends State<FileInputForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  Future<Response>? _futureResponse;

  Future<Response> _insertFunder(String file) async {
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('http://localhost:2021/experience'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'file': file,
      }),
    );

    if (response.statusCode == 202) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Response.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  FutureBuilder<Response> buildFutureBuilder() {
    return FutureBuilder<Response>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.status);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  ListView buildListView(){
    return ListView(
      children: <Widget>[
        TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.picture_as_pdf),
            hintText: 'Dalam kg',
            labelText: 'Berat',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        Container(
          width: 200,
          height: 45,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xffF18265),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              setState(() {
                _futureResponse = _insertFunder(_amountController.text);
              });
            },
            child: Text(
              "Kirim Data",
              style: TextStyle(
                color: Color(0xffffffff),
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child:  (_futureResponse == null) ? buildListView() : buildFutureBuilder(),
    );
  }
}

class Response {
  final String status;

  const Response({required this.status});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
    );
  }
}