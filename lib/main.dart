import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:my_friends/view_contact_page.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 200,
          width: 400,
        ),
      ),
    );
  }
}


class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String selectedRole = 'Dom';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void addContact() {
    Map<String, dynamic> contact = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'role': selectedRole,
      'relationshipValue': 0,
      'description': descriptionController.text,
    };
    Navigator.pop(context, contact);
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
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Zdjęcie',
                        style: TextStyle(fontSize: 16),
                      ),
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
                            .map((role) => DropdownMenuItem<String>(
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
              maxLines: 13,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Opis',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addContact,
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> domContacts = [];
  List<Map<String, dynamic>> friendContacts = [];
  List<Map<String, dynamic>> workContacts = [];

  void loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domContacts = jsonDecode(prefs.getString('domContacts') ?? '[]').cast<Map<String, dynamic>>();
    friendContacts = jsonDecode(prefs.getString('friendContacts') ?? '[]').cast<Map<String, dynamic>>();
    workContacts = jsonDecode(prefs.getString('workContacts') ?? '[]').cast<Map<String, dynamic>>();
  }


  void saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('domContacts', jsonEncode(domContacts));
    prefs.setString('friendContacts', jsonEncode(friendContacts));
    prefs.setString('workContacts', jsonEncode(workContacts));
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }



  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddContactPage(),
          ),
        ).then((newContact) {
          if (newContact != null) {
            setState(() {
              switch (newContact['role']) {
                case 'Dom':
                  domContacts.add(newContact);
                  break;
                case 'Przyjaciel':
                  friendContacts.add(newContact);
                  break;
                case 'Praca':
                  workContacts.add(newContact);
                  break;
              }
              saveContacts(); // Zapisz kontakty po dodaniu nowego
            });
          }
        });
      }
    });
  }


  List<Map<String, dynamic>> getContactsByIndex(int index) {
    switch (index) {
      case 0:
        return domContacts;
      case 1:
        return friendContacts;
      case 3:
        return workContacts;
      case 4:
        return domContacts + friendContacts + workContacts;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentContacts = getContactsByIndex(_selectedIndex);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Spacer(),
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 150,
                  width: 300,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 3 || _selectedIndex == 4)
          ? GridView.extent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        padding: EdgeInsets.all(15),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: List.generate(currentContacts.length, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewContactPage(
                      firstName: currentContacts[index]['firstName'],
                      lastName: currentContacts[index]['lastName'],
                      role: currentContacts[index]['role'],
                      description: currentContacts[index]['description'],
                      relationshipValue: currentContacts[index]['relationshipValue'],

                  ),
                ),
              );
            },
            child: Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/contact_image.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 5),
                  Text('${currentContacts[index]['firstName']} ${currentContacts[index]['lastName']}'),

                  Padding(
                    padding: EdgeInsets.only(top: 4.0),  // Dodaj padding na górze
                    child: Container(
                      width: 120,  // Tu wprowadź preferowaną szerokość
                      child: LinearProgressIndicator(
                        value: (currentContacts[index]['relationshipValue'] + 100) / 200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            currentContacts[index]['relationshipValue'] <= -1
                                ? Colors.red
                                : currentContacts[index]['relationshipValue'] == 0
                                ? Colors.grey
                                : Colors.green
                        ),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ),



                  Text(' ${currentContacts[index]['relationshipValue']}'),

                  Text(currentContacts[index]['role']),
                ],
              ),
            ),
          );
        }),
      )
          : Center(
        child: Text('Placeholder for other pages'),
      ),



      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Work',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: 'All',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'My App',
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
    ),
    home: SplashScreen(), // Ekran powitalny jako strona główna
    routes: {

      '/home': (context) => MyHomePage(), // Strona główna
      '/addContact': (context) => AddContactPage(),
    },
  ));
}