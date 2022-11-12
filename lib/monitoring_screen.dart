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

  Future<List<dynamic>> _fetchExprienceData() async {
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
        future: _fetchExprienceData(),
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
                      subtitle: Text("Nama : " + snapshot.data[index]['name'] + " \nTotal Panen : " + snapshot.data[index]['total_spawning'].toString() + " kg\nTipe Ikan : " + snapshot.data[index]['fish_type']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FunderDetailScreen(nik: snapshot.data[index]['nik']),
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


class FunderDetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const FunderDetailScreen({super.key, required this.nik});

  // Declare a field that holds the Todo.
  final String nik;

  Future<List<dynamic>> _fecthFunderData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/funder/' + this.nik),
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
          title: Text("Details of nik " + nik),
        ),
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
                            leading: FlutterLogo(),
                            title: Text("Di setujui oleh : " + snapshot.data[index]['Funder']),
                            subtitle: Text("Tanggal : " + snapshot.data[index]['Timestamp'] + "\nJumlah Kolam : " + snapshot.data[index]['Numofponds'].toString() + "\nJumlah Pemodalan : " + snapshot.data[index]['Amountoffund'].toString() + "\n\n Tekan untuk melihat file url"),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MonitoringDetailScreen(fundid: snapshot.data[index]['Fundid'])));
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
    );

  }
}

class MonitoringDetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const MonitoringDetailScreen({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  Future<List<dynamic>> _fetchMonitoringData() async {
    var token = await storage.read(key: 'token');
    debugPrint("Fund ID : " +  fundid);
    var result = await http.get(
        Uri.parse('http://localhost:2021/monitoring_pond/' + this.fundid),
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
        title: Text("Details of monitoring "),
      ),
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
                          subtitle: Text("Tanggal : " + snapshot.data[index]['Timestamp'] + "\nBerat : " + snapshot.data[index]['Weight'].toString() + "\nTemperatur : " + snapshot.data[index]['Temperature'].toString() + "\Kelembapan : " + snapshot.data[index]['Humidity'].toString() +"\n\n Tekan untuk melihat file url"),

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileInput(fundid: this.fundid)));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );

  }
}

class FileInput extends StatelessWidget {

  // In the constructor, require a Todo.
  const FileInput({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Pendanaan"),
      ),
      body: FileInputForm(fundid: this.fundid),
    );
  }
}

// Create a Form widget.
class FileInputForm extends StatefulWidget {

  // In the constructor, require a Todo.
  const FileInputForm({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

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
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();


  Future<Response>? _futureResponse;

  Future<Response> _insertMonitoring(String fishtype, int numberofponds, int amountofpond) async {
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('http://localhost:2021/monitoring_pond'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'nik': widget.fundid,
        'fish_type' : fishtype,
        'number_of_ponds' : numberofponds,
        'amount_of_fund' : amountofpond
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
          controller: _weightController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.scale),
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
        TextFormField(
          controller: _temperatureController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.add_chart_rounded),
            hintText: 'Dalam celcius',
            labelText: 'Temperature',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _humidityController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.picture_as_pdf),
            hintText: 'Dalam RH',
            labelText: 'Kelembapan',
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
                _futureResponse = _insertMonitoring(_weightController.text, int.parse(_temperatureController.text), int.parse(_humidityController.text));
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