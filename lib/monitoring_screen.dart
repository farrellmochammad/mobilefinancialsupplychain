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
                          title: Text("Fund ID : " + snapshot.data[index]['fund_id']),
                          subtitle: Text("Total Panen : " + snapshot.data[index]['total_spawning'].toString() + " kg\nTipe Ikan : " + snapshot.data[index]['fish_type']),
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MonitoringInput()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}


class MonitoringInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Add monitoring"),
          ),
        body: MonitoringForm(),
      );
  }
}

// Create a Form widget.
class MonitoringForm extends StatefulWidget {
  @override
  MonitoringFormState createState() {
    return MonitoringFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MonitoringFormState extends State<MonitoringForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();

  Future<Response>? _futureResponse;

  Future<Response> _insertMonitoring(int weight,int temperature,int humidity) async {
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('http://localhost:2021/experience'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'weight': weight,
        'temperature': temperature,
        'humidity': humidity,
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
            icon: const Icon(Icons.monitor_weight_outlined),
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
            icon: const Icon(Icons.severe_cold),
            hintText: 'Dalam Celcius',
            labelText: 'Suhu',
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
            icon: const Icon(Icons.add_box_rounded),
            hintText: 'Dalam persen',
            labelText: 'Tingkat Kelembapan',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid phone number';
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
                _futureResponse = _insertMonitoring(int.parse(_weightController.text),int.parse(_temperatureController.text), int.parse(_humidityController.text));
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
