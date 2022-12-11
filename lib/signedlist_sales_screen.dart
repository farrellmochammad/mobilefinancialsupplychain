import 'package:flutter/material.dart';
import 'dart:convert';
import 'Component/dialog.dart';
import 'farmer_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Component/appbar.dart';
import 'farmer_update.dart';
import 'const/const.dart';

final storage = const FlutterSecureStorage();

class SignedListSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignedListViewSales(),

      ),
    );
  }
}

class SignedListViewSales extends StatelessWidget {

  Future<List<dynamic>> _fetchFundersData() async {
    var token = await storage.read(key: 'token');
    var result = await http.get(
        Uri.parse(url_api + '/funders_sales'),
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
                      title: Text("Fund Id : " + snapshot.data[index]['fund_id']),
                      subtitle: Text(
                          "Nik : " + snapshot.data[index]['nik'] +
                          "\nJumlah Kolam : " + snapshot.data[index]['number_of_ponds'].toString() +
                          "\nJumlah Pendanaan : Rp " + snapshot.data[index]['amount_of_fund'].toString() +
                          "\nTipe Ikan : " + snapshot.data[index]['fish_type']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignedInputForm(
                                    fundid: snapshot.data[index]['fund_id']),
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

// Create a Form widget.dwdawdaw
class SignedInputForm extends StatefulWidget {
  // In the constructor, require a Todo.
  const SignedInputForm({super.key, required this.fundid});

  // Declare a field that holds the Todo.
  final String fundid;

  @override
  SignedInputFormState createState() {
    return SignedInputFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class SignedInputFormState extends State<SignedInputForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fileController = TextEditingController();

  Future<Response>? _futureResponse;
  String? nik;

  Future<Response> _insertSigned(String imageurl) async {
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse(url_api + '/sign'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer: ' + token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'fund_id' : widget.fundid,
        'sign_url' : imageurl
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
          controller: _fileController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.picture_as_pdf),
            hintText: 'Link URL gambar',
            labelText: 'Link URL gambar',
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
                _futureResponse = _insertSigned(_fileController.text);
              });
            },
            child: Text(
              "Simpan",
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
      appBar: AppBarComponent.CreateAppBar("Upload terima modal"),
      body: Form(
        key: _formKey,
        child:  (_futureResponse == null) ? buildListView() : buildFutureBuilder(),
      ),
    );
  }
}

class Response {
  final String status;

  const Response({required this.status});

  String getStatus(){
    return this.status;
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
    );
  }
}