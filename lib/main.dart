import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:my_friends/view_contact_page.dart';
import 'package:provider/provider.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'theme_manager.dart';
import 'themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_friends/ad_mob_service.dart';  // Import your AdMobService here
import 'package:google_mobile_ads/google_mobile_ads.dart';




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

  File? _image;
  final picker = ImagePicker();

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

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

  void addContact() {
    Map<String, dynamic> contact = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'role': selectedRole,
      'relationshipValue': 0,
      'description': descriptionController.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,  // Dodajemy timestamp
      'imagePath': _image?.path,  // Dodajemy ścieżkę do zdjęcia
    };
    Navigator.pop(context, contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ADD NEW FRIEND',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
              controller: descriptionController,
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

  Future<void> loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domContacts = jsonDecode(prefs.getString('domContacts') ?? '[]').cast<Map<String, dynamic>>();
    friendContacts = jsonDecode(prefs.getString('friendContacts') ?? '[]').cast<Map<String, dynamic>>();
    workContacts = jsonDecode(prefs.getString('workContacts') ?? '[]').cast<Map<String, dynamic>>();
  }

  void _contactRemover(int index) {
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
                setState(() {
                  // Usuwanie kontaktu na podstawie indeksu
                  switch (_selectedIndex) {
                    case 0:
                      domContacts.removeAt(index);
                      break;
                    case 1:
                      friendContacts.removeAt(index);
                      break;
                    case 3:
                      workContacts.removeAt(index);
                      break;
                  }
                  saveContacts();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await loadContacts();
      setState(() {});
    });
  }
  void deleteAllContacts() {
    domContacts.clear();
    friendContacts.clear();
    workContacts.clear();
    saveContacts();
  }


  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
/* */      if (index == 2) {
        _selectedIndex = 0;
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
              saveContacts();
              // Zapisz kontakty po dodaniu nowego
            });
          }
        });
      }
    });
  }
  void showSortMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    title: Text('Domyślnie'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                        friendContacts.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                        workContacts.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    title: Text('Alfabetycznie (od A do Z)'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => a['firstName'].compareTo(b['firstName']));
                        friendContacts.sort((a, b) => a['firstName'].compareTo(b['firstName']));
                        workContacts.sort((a, b) => a['firstName'].compareTo(b['firstName']));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    title: Text('Alfabetycznie (od Z do A)'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => b['firstName'].compareTo(a['firstName']));
                        friendContacts.sort((a, b) => b['firstName'].compareTo(a['firstName']));
                        workContacts.sort((a, b) => b['firstName'].compareTo(a['firstName']));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    title: Text('Numerycznie (od 0 do 100)'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => a['relationshipValue'].compareTo(b['relationshipValue']));
                        friendContacts.sort((a, b) => a['relationshipValue'].compareTo(b['relationshipValue']));
                        workContacts.sort((a, b) => a['relationshipValue'].compareTo(b['relationshipValue']));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    title: Text('Numerycznie (od 100 do 0)'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => b['relationshipValue'].compareTo(a['relationshipValue']));
                        friendContacts.sort((a, b) => b['relationshipValue'].compareTo(a['relationshipValue']));
                        workContacts.sort((a, b) => b['relationshipValue'].compareTo(a['relationshipValue']));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    title: Text('Data dodania (od najnowszej do najstarzszej)'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
                        friendContacts.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
                        workContacts.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    title: Text('Data dodania (od najstarszej do najnowszej)'),
                    onTap: () {
                      setState(() {
                        domContacts.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                        friendContacts.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                        workContacts.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                        saveContacts();
                      });
                      Navigator.pop(context);
                    }
                ),

              ],
            ),
          );
        }
    );
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Spacer(),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 150,
                  width: 200,
                ),
              ),
            ),

            IconButton(
              icon: Icon(Icons.sort_by_alpha),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () {
                showSortMenu(context);  // Pokazuje menu sortowania
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).colorScheme.onSurface,
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
              ).then((updatedValue) {
                if (updatedValue != null) {
                  setState(() {
                    currentContacts[index]['relationshipValue'] = updatedValue;
                    saveContacts();
                  });
                }
              });
            },
            onLongPress: () {
              _contactRemover(index); // Wywołanie metody _contactRemover
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
                        backgroundColor: Theme.of(context).colorScheme.surface,
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
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
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
  runApp(
    ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager(lightTheme),
      child: Consumer<ThemeManager>(
        builder: (context, theme, child) {
          return MaterialApp(
            title: 'My App',
            theme: theme.getTheme(),
            home: SplashScreen(),
            routes: {
              '/home': (context) => MyHomePage(),
              '/addContact': (context) => AddContactPage(),
            },
          );
        },
      ),
    ),
  );
}