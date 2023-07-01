import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('SETTINGS'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              onTap: () {
                // Do something when Language is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Do something when Notifications is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text('Themes'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Theme'),
                      children: <Widget>[
                        ListTile(
                          title: const Text('Light'),
                          onTap: () {
                            setState(() {
                              _themeMode = ThemeMode.light;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Dark'),
                          onTap: () {
                            setState(() {
                              _themeMode = ThemeMode.dark;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        ButtonBar(
                          children: <Widget>[
                            TextButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Update the theme mode of your app
                                // You should have a callback to your main.dart file here
                                // Use a state management solution like Provider, Redux, etc.
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(),
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Do something when Profile is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),
          ],
        ),
      ),
    );
  }
}
