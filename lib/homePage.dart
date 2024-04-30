import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController surName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController loginId = TextEditingController();
  DateTime? _selectedDate;
  int _selectedOption = 0;
  File _imageFile = File("");
  String _message = '';

  Future<void> _selectImage() async {
    final pickImg =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickImg != null) {
        _imageFile = File(pickImg.path);
        print("Img : ${_imageFile}");
      } else {
        print("No img Found!");
      }
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('users').add({
        'name': name.text,
        'surname': surName.text,
        'mobileNo': mobileNo.text,
        'loginId': loginId.text,
        'gender': _selectedOption == 0 ? 'Male' : 'Female',
        'selectedDate': _selectedDate,
      }).then((value) {
        print('Data added to Firestore');
        setState(() {
          _message = 'Form submitted successfully!';
          name.text = "";
          surName.text = "";
          mobileNo.text = "";
          _selectedOption = 0;
          loginId.text = "";
          _selectedDate;
        });
      }).catchError((error) {
        print('Error adding data to Firestore: $error');
        setState(() {
          _message = 'Error: Form submission failed!';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: surName,
                  decoration: InputDecoration(labelText: "Surname"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a surname";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: mobileNo,
                  decoration: InputDecoration(labelText: "Mobile Number"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a Mobile No";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: loginId,
                  decoration: InputDecoration(labelText: "Login Id"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a login Id";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Select Gender"),
                    Radio(
                      value: 0,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value as int;
                        });
                      },
                    ),
                    Text("Male"),
                    Radio(
                      value: 1,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value as int;
                        });
                      },
                    ),
                    Text("Female"),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Select Date"),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              _selectedDate = value;
                            });
                          }
                        });
                      },
                      child: Text(_selectedDate == null
                          ? "Select Date"
                          : _selectedDate!.toString()),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _imageFile.path.isNotEmpty
                    ? Image.file(
                        _imageFile,
                        height: 100,
                      )
                    : GestureDetector(
                        onTap: () {
                          _selectImage();
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration:
                              BoxDecoration(border: Border.all(width: 2)),
                          child: Center(child: Text("Upload Image")),
                        ),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text("Submit"),
                ),
                SizedBox(height: 10),
                _message.isNotEmpty
                    ? Text(
                        _message,
                        style: TextStyle(
                            color: _message.contains('Error')
                                ? Colors.red
                                : Colors.green),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
