import 'package:flutter/material.dart';
import 'dart:convert';
import 'farmer_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Component/appbar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'farmer_update.dart';
import 'Component/dialog.dart';
import 'Component/appbar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    var result = await http.get(Uri.parse('http://localhost:2021/experiences_sales'),
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
        Uri.parse('http://localhost:2021/funder_nik/' + this.nik),
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
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreenApprovedList(
                                    fundid: snapshot.data[index]['fund_id']
                              ),
                            ));
                          },
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
      floatingActionButton: SpeedDial( //Speed dial menu
        marginBottom: 10, //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.deepOrangeAccent, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor: Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: 56.0, //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0, //shadow elevation of button
        shape: CircleBorder(), //shape of button

        children: [
          SpeedDialChild( //speed dial child
            child: Icon(Icons.person_pin),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Update Data',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => {
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
              )),
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Update Funder menu',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FunderSubmissionForm(
                    nik: this.nik,
                    startfarming: this.startfarming,
              ))),
            },
          ),
          //add more menu item childs here
        ],
      ),
    );
  }
}


class DetailScreenApprovedList extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreenApprovedList({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  Future<List<dynamic>> _fecthExperienceData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/experiences_sales/' + this.fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
    return json.decode(result.body)['data'];
  }

  Widget _getRadialGauge(double creditscore) {
    debugPrint("Credit score : " + creditscore.toString());
    return SfRadialGauge(
      axes:<RadialAxis>[
        RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
            minimum: 0, maximum: 300,
            ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 100,
                color: Color(0xFFFE2A25), label: 'Rendah',
                sizeUnit: GaugeSizeUnit.factor,
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:  20),
                startWidth: 0.65, endWidth: 0.65
            ),GaugeRange(startValue: 100, endValue: 200,
              color:Color(0xFFFFBA00), label: 'Sedang',
              labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
              startWidth: 0.65, endWidth: 0.65, sizeUnit: GaugeSizeUnit.factor,
            ),
              GaugeRange(startValue: 200, endValue: 300,
                color:Color(0xFF00AB47), label: 'Tinggi',
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                sizeUnit: GaugeSizeUnit.factor,
                startWidth: 0.65, endWidth: 0.65,
              ),

            ],
            pointers: <GaugePointer>[NeedlePointer(value: creditscore
            )]
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBarComponent.CreateAppBar("Detail of fund"),
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
                      return  Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Card(
                            child: ListTile(
                              title: Text('Fund ID : ' + this.fundid),
                              subtitle: Text("Disubmit oleh : " +
                                  snapshot.data[index]['Submitby'] +
                                  "\nWaktu submit : " +
                                  snapshot.data[index]['Timestamp'] +
                                  "\nJumlah Kolam : " +
                                  snapshot.data[index]['Numofponds']
                                      .toString() +
                                  "\nKredit skor : " +
                                  snapshot.data[index]['Creditscore']
                                      .toString()),

                            ),
                          ),
                          _getRadialGauge( snapshot.data[index]['Creditscore'])],
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


// Create a Form widget.dwdawdaw
class FunderSubmissionForm extends StatefulWidget {
  // In the constructor, require a Todo.
  const FunderSubmissionForm({super.key, required this.nik, required this.startfarming});

  // Declare a field that holds the Todo.
  final String nik;
  final String startfarming;

  @override
  FunderSubmissionFormState createState() {
    return FunderSubmissionFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class FunderSubmissionFormState extends State<FunderSubmissionForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fishtypeController = TextEditingController();
  final TextEditingController _numofpondsController = TextEditingController();

  Future<Response>? _futureResponse;
  String? nik;

  Future<Response> _insertFundSubmission(String fishtype, int numberofponds) async {
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('http://localhost:2021/funder_submission'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'nik' : widget.nik,
        'start_farming' : widget.startfarming,
        'fish_type' : fishtype,
        'number_of_ponds' : numberofponds
      }),
    );

    if (response.statusCode == 202) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Response.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Insert sign.');
    }
  }

  FutureBuilder<Response> buildFutureBuilder() {
    return FutureBuilder<Response>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertComponent().CreateAlertDialog(context, snapshot.data!.status);
        } else if (snapshot.hasError) {
          return AlertComponent().CreateAlertDialog(context, snapshot.error.toString());
        }

        return const CircularProgressIndicator();
      },
    );
  }

  ListView buildListView(){
    return ListView(
      children: <Widget>[
        TextFormField(
          controller: _fishtypeController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.picture_as_pdf),
            hintText: 'Masukan jenis ikan ',
            labelText: 'masukan jenis ikan',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _numofpondsController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.picture_as_pdf),
            hintText: 'Masukan jumlah kolam ',
            labelText: 'masukan jumlah kolam ',
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
                _futureResponse = _insertFundSubmission(_fishtypeController.text, int.parse(_numofpondsController.text));
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
    return Scaffold(
      appBar: AppBarComponent.CreateAppBar("Upload pengajuan pendanaan baru"),
      body: Form(
        key: _formKey,
        child:  (_futureResponse == null) ? buildListView() : buildFutureBuilder(),
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
