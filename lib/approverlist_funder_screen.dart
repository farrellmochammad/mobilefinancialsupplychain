import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Pdfviewer_screen.dart';
import 'Component/appbar.dart';
import 'Component/dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  Future<List<dynamic>> _fetchFundersData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/funders_funder'),
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
                                FunderDetailScreen(
                                    nik: snapshot.data[index]['nik']),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else {
            return Center(child: Text("Belum ada data petani yang di funding"));
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
        Uri.parse('http://localhost:2021/funder_nik/' + this.nik),
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
      appBar: AppBarComponent.CreateAppBar("Details funder "),
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
                            title: Text('Nik : ' + this.nik),
                            subtitle: Text("Disubmit oleh : " +
                                snapshot.data[index]['submitted_by'] +
                                "\nWaktu submit : " +
                                snapshot.data[index]['submitted_timestamp'] +
                                "\nJenis Ikan : " +
                                snapshot.data[index]['fish_type'].toString() +
                                "\nStatus : " +
                                snapshot.data[index]['status'] +
                                "\nJumlah Kolam : " +
                                snapshot.data[index]['number_of_ponds']
                                    .toString() +
                                "\nJumlah Pendanaan : " +
                                snapshot.data[index]['amount_of_fund']
                                    .toString()),
                            onTap: () {
                              if (!snapshot.data[index]['status'].toString().contains('Rejected')){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreenApprovedList(fundid:  snapshot.data[index]['fund_id']),
                                  ),
                                );
                              }
                            }
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

class DetailScreenApprovedList extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreenApprovedList({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  Future<List<dynamic>> _fecthExperienceData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse('http://localhost:2021/experience_fund/' + this.fundid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer: ' + token.toString(),
        });
    return json.decode(result.body)['data'];
  }


  Future<Response> _rejectfundData(String fundid) async {
    var token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('http://localhost:2021/insertfunderrejected'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'fund_id' : fundid
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
                      return Container(
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
            child: Icon(Icons.close),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Reject',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Reject Status'),
                content: Text('Fund id ' + this.fundid + ' rejected'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => {
                      _rejectfundData(this.fundid),
                      Navigator.pop(context, 'OK')
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.done_all),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Approve',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FundInput(fundid: this.fundid)))
            },
          ),
          //add more menu item childs here
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //         Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => FundInput(fundid: this.fundid)));},
      //   label: const Text('Beri Pendanaan'),
      //   icon: const Icon(Icons.thumb_up),
      //   backgroundColor: Colors.pink,
      // ),
    );
  }
}

class FundInput extends StatelessWidget {
  // In the constructor, require a Todo.
  const FundInput({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent.CreateAppBar("Form Pendanaan"),
      body: FundInputForm(fundid: this.fundid),
    );
  }
}

// Create a Form widget.
class FundInputForm extends StatefulWidget {
  // In the constructor, require a Todo.
  const FundInputForm({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  @override
  AmountInputFormState createState() {
    return AmountInputFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class AmountInputFormState extends State<FundInputForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fundController = TextEditingController();

  Future<Response>? _futureResponse;

  Future<Response> _insertFunder( int amountoffund) async {
    var token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('http://localhost:2021/insertfunder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'fund_id': widget.fundid,
        'amount_of_fund' : amountoffund
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

  ListView buildListView() {
    return ListView(
      children: <Widget>[
        TextFormField(
          controller: _fundController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.add_card_sharp),
            hintText: 'Dalam Rp',
            labelText: 'Masukan Jumlah Pendanaan',
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
                _futureResponse = _insertFunder(
                    int.parse(_fundController.text)
                    );
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
      child: (_futureResponse == null) ? buildListView() : buildFutureBuilder(),
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
