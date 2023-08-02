import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  
  String? get source => null;
  bool isValidDateKey(String dateKey) {
    // Define the date key pattern (YYYY-MM-DD)
    final RegExp dateKeyPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

    if (!dateKeyPattern.hasMatch(dateKey)) {
      // Date key format is invalid
      return false;
    }

    try {
      // Attempt to parse the date key
      DateTime.parse(dateKey);
      return true;
    } catch (e) {
      // Date key is not a valid date
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Form'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/show'); // This pops the current route and goes back
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'CLIENT NAME',
                    icon: const Icon(Icons.drive_file_rename_outline),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(00.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return 'Please enter more than three characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'DATE',
                    icon: const Icon(Icons.calendar_today_rounded),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(00.0)),
                  ),
                  //logout ekada show.dart lo petadama?
                  //registration ? lo pedadama
                  onTap: () async {
                    DateTime? today = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));
                    if (today != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(today);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || !isValidDateKey(value)) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                ), //lok
                const SizedBox(height: 16.0),
                TextFormField(
                  // onCountryChanged: (phone){
                  //   //selectedCountryCode=phone.fullCountryCode;
                  //   initialCountryCode=phone.fullCountryCode;
                  // },
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'PHONE',
                    icon: const Icon(Icons.phone),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                  ),
                  // initialCountryCode:countrycode, //ikkada error coming
                  validator: (value) {
                    bool isValid = RegExp(r'^\d{10}$').hasMatch(value!);

                    //phone = value.number;
                    // countryisocode=value.countryISOCode;

                    //return mobileNumberPattern.hasMatch(phoneNumber);
                    if (!isValid) {
                      return 'Please enter 10 digits only';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'EMAIL ID',
                    icon: const Icon(Icons.email),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(00.0)),
                  ),
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'Please enter a valid email ID';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'PRICE',
                    icon: const Icon(Icons.attach_money),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(00.0)),
                  ),
                  validator: (value) {
                    bool isValid = RegExp(r'^\d+(\.\d+)?$').hasMatch(value!);
                    if (!isValid) {
                      return 'Please enter only digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _commentsController,
                  decoration: InputDecoration(
                    labelText: 'COMMENTS',
                    icon: const Icon(Icons.comment),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 5),
                        borderRadius: BorderRadius.circular(00.0)),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[200],
                    foregroundColor: Colors.black,
                    fixedSize: const Size(100, 48),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Process the form data
                      String name = _nameController.text;
                      String date = _dateController.text;
                      String phone = _phoneController.text;
                      String email = _emailController.text;
                      String price = _priceController.text;
                      String comments = _commentsController.text;

                      // Print or use the form data
                      await users.add({
                        'name': name,
                        'date': date,
                        //'countrycode':countrycode,
                        //'countryisocode':countryisocode,
                        'phone': phone,
                        'email': email,
                        'price': price,
                        'comments': comments,
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Submitted successfully!'),
                          ),
                        );
                        print("User Added");
                        _nameController.text = "";
                        _dateController.text = "";
                        _phoneController.text = "";
                        _emailController.text = "";
                        _priceController.text = "";
                        _commentsController.text = "";
                        phone = "";
                        //countryisocode="";
                        //countrycode="";
                      }).catchError(
                          (error) => print("Failed to add user: $error"));
                      print('Client Name: $name');
                      print('Date: $date');
                      print('Phone Number: $phone');
                      print('Email ID: $email');
                      print('Price: $price');
                      print('Comments: $comments');
                      context.go('/show');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
