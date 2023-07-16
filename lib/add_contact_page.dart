import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_friends/ad_mob_service.dart';


class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String selectedRole = 'Dom';
  int relationshipValue = 0;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ADD NEW FRIEND',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      pickImageFromGallery();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage('assets/images/placeholder.png') as ImageProvider<Object>
                              : FileImage(_image!) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: _image == null
                          ? Center(
                        child: Text(
                          'Zdjęcie',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Imię',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Nazwisko',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Rola',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Dom', 'Przyjaciel', 'Praca']
                            .map((role) =>
                            DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              maxLines: 13,
              decoration: InputDecoration(
                labelText: 'Opis',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> contact = {
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                  'role': selectedRole,
                  'description': descriptionController.text,
                  'relationshipValue': relationshipValue,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,  // Dodajemy timestamp
                  'imagePath': _image?.path,  // Dodajemy ścieżkę do zdjęcia
                };
                Navigator.pop(context, contact);
              },
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}
