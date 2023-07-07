import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewContactPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String role;
  final String description;
  final int relationshipValue;

  ViewContactPage({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.description,
    required this.relationshipValue,
  });

  @override
  _ViewContactPageState createState() => _ViewContactPageState();
}

class _ViewContactPageState extends State<ViewContactPage> {
  late int relationshipValue;
  File? _image;
  final picker = ImagePicker();

  // Kontrolery
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController roleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    relationshipValue = widget.relationshipValue;

    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    roleController = TextEditingController(text: widget.role);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    roleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  Color _getRelationshipColor() {
    if (relationshipValue <= -1) {
      return Colors.red;
    } else if (relationshipValue == 0) {
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }

  void _increaseRelationship() {
    setState(() {
      relationshipValue += 1;
      if (relationshipValue > 100) {
        relationshipValue = 100;
      }
    });
  }

  void _decreaseRelationship() {
    setState(() {
      relationshipValue -= 1;
      if (relationshipValue < -100) {
        relationshipValue = -100;
      }
    });
  }

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

  Future pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Dodaj z galerii'),
                  ),
                  onTap: () {
                    pickImageFromGallery();
                    Navigator.pop(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                GestureDetector(
                  child: ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Dodaj z aparatu'),
                  ),
                  onTap: () {
                    pickImageFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _contactRemover() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Contact'),
          content: Text('Are you sure you want to remove this contact?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                // Wywołaj kod usuwający kontakt
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, relationshipValue);
        return false; // Prevent the automatic pop of the route
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context, relationshipValue);
            },
          ),
          title: Text(
            'VIEW CONTACT',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.all(15),
              icon: Icon(Icons.delete_forever_outlined),
              color: Colors.red,
              onPressed: () {
                _contactRemover();
              },
            ),
          ],
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
                        _showPicker(context);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage('assets/images/placeholder.png') as ImageProvider<Object> // replace this with your placeholder image
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
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Imię',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: lastNameController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Nazwisko',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: roleController,
                          readOnly: true,  // Opcjonalne, jeżeli nie chcesz, aby użytkownik mógł edytować rolę
                          decoration: InputDecoration(
                            labelText: 'Rola',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: (relationshipValue + 100) / 200, // Przekształcenie wartości na zakres 0-1
                valueColor: AlwaysStoppedAnimation<Color>(_getRelationshipColor()),
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 12,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Opis',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: _decreaseRelationship,
                    child: Text('Zmniejsz'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: _increaseRelationship,
                    child: Text('Zwiększ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}