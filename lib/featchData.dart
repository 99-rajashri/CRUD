import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/homePage.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      appBar: AppBar(
        title: Text("User Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          return ListTile(
                            title: Text(data['name']),
                            subtitle: Text(data['surname']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _nameController.text = data['name'];
                                    _surnameController.text = data['surname'];
                                    _showEditBottomSheet(context, document.id);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteDialog(context, document.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, String documentId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Surname'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _updateUserData(documentId);
                  Navigator.pop(context);
                },
                child: Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateUserData(String documentId) {
    FirebaseFirestore.instance.collection('users').doc(documentId).update({
      'name': _nameController.text,
      'surname': _surnameController.text,
    }).then((value) {
      print('User data updated successfully');
    }).catchError((error) {
      print('Error updating user data: $error');
    });
  }

  void _showDeleteDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteUserData(documentId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUserData(String documentId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .delete()
        .then((value) {
      print('User data deleted successfully');
    }).catchError((error) {
      print('Error deleting user data: $error');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }
}
