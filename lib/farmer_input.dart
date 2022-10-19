import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
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
            decoration: const InputDecoration(
              icon: const Icon(Icons.area_chart),
              hintText: 'Enter your date of birth',
              labelText: 'Input Domisili',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid date';
              }
              return null;
            },
          ),
          Text("Informasi kolam : "),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.panorama_fish_eye),
              hintText: 'nama kolam',
              labelText: 'Input nama kolam',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid date';
              }
              return null;
            },
          ),
          TextFormField(
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
              onPressed: () {},
              child: Text(
                "Kirim Data",
                style: TextStyle(
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}