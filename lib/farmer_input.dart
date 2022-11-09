import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();

Future<Response> insertFarmer(String nik,String name,String phone,String dob,String address,String startfarming,String fishtype,int numberofponds,String notes) async {
  var token = await storage.read(key: 'token');
  debugPrint('token : ' + token.toString());
  final response = await http.post(
    Uri.parse('http://localhost:2021/experience'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer: ' + token.toString(),
    },
    body: jsonEncode(<String, dynamic>{
      'nik': nik,
      'name': name,
      'phone': phone,
      'dob': dob,
      'address': address,
      'start_farming': startfarming,
      'fish_type': fishtype,
      'number_of_ponds': numberofponds,
      'notes': notes,
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

class FarmerInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: InputDataForm(),
      ),
    );
  }
}
// Create a Form widget.
class InputDataForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
// Create a corresponding State class, which holds data related to the form.
class MyCustomFormState extends State<InputDataForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _startFarmingController = TextEditingController();
  final TextEditingController _fishTypeController = TextEditingController();
  final TextEditingController _numberOfPondsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Future<Response>? _futureResponse;

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
          controller: _nikController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.perm_identity),
            hintText: 'NIK petani (12 digit)',
            labelText: 'Input NIK Petani',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.person_pin_sharp),
            hintText: 'Input nama lengkap petani',
            labelText: 'Input Nama Petani',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.phone),
            hintText: 'Nomor hp petani',
            labelText: 'Input Nomor Hp',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid phone number';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _dobController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.area_chart),
            hintText: 'Input Tanggal Lahir',
            labelText: 'Input Tanggal lahir',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid date';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.area_chart),
            hintText: 'Input Alamat',
            labelText: 'Input Alamat',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid date';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _startFarmingController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.area_chart),
            hintText: 'Input mulai budi daya ikan',
            labelText: 'Input mulai budi daya ikan',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid date';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _fishTypeController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.living_outlined),
            hintText: 'Jenis Ikan',
            labelText: 'Input jenis ikan',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid date';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _numberOfPondsController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.living_outlined),
            hintText: 'Jumlah Kolam',
            labelText: 'Input jumlah kolam',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid date';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Notes',
            labelText: 'Notes',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid date';
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
                _futureResponse = insertFarmer(_nikController.text, _nameController.text, _phoneController.text, _dobController.text, _addressController.text, _startFarmingController.text, _fishTypeController.text, int.parse(_numberOfPondsController.text), _notesController.text);
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