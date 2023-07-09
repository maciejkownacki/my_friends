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
      body: SingleChildScrollView(
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
              subtitle: Text('TODO:'),

              onTap: () {
                // Do something when Language is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('TODO:'),

              onTap: () {
                // Do something when Notifications is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text('Themes'),
              subtitle: Text('TODO:'),
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
              subtitle: Text('TODO: (moze strona view page dla myself)'),

              onTap: () {
                // Do something when Profile is tapped
              },
            ),


            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              subtitle: Text('TODO:'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),

            ListTile(
              leading: Icon(Icons.adb),
              title: Text('Ads settings'),
              subtitle: Text('TODO:'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),

            ListTile(
              leading: Icon(Icons.delete_forever_sharp),
              title: Text('Delete stored data'),
              subtitle: Text('TODO:'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),




            Divider(),
            Text(
              'Share',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),


            ListTile(
              leading: Icon(Icons.star_half),
              title: Text('Rate app'),
              subtitle: Text('TODO: Tap to rate app'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),

            ListTile(
              leading: Icon(Icons.share_rounded),
              title: Text('Share app'),
              subtitle: Text('TODO: Tap to share app'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),

            ListTile(
              leading: Icon(Icons.comment),
              title: Text('Share feedback'),
              subtitle: Text('TODO: Tap to share mail to developer'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),


            Divider(),
            Text(
              'Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              subtitle: Text('TODO: on click send mail to developer or open FAQ page'),
              onTap: () {
                // Do something when Change Password is tapped
              },
            ),


            Divider(),
            Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            ListTile(
              leading: Icon(Icons.person),
              title: Text('Developed by:'),
              subtitle: Text('Maciej Kownacki'),
              onTap: () {},
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: Text('😉', textScaleFactor: 4, )),
                    duration: const Duration(milliseconds: 2000),
                    width: 130.0, // zwiększona szerokość SnackBar
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    backgroundColor: Colors.white,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Version'),
              subtitle: Text('Wersja 0.0.7'),
              onTap: () {

              },
            ),



            //________________________________________
          ],
        ),
      ),
    );
  }
}
