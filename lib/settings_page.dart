import 'package:flutter/material.dart';
import 'package:open_share_plus/open.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = ThemeMode.light;

  void shareApp() {
    final String appLink = 'https://duckduckgo.com/app-link'; // Zaktualizuj link do aplikacji

    Share.share('Check out this amazing app: $appLink');
  }




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
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Language'),
                        children: <Widget>[
                          ListTile(
                              title: const Text('Polski'),
                              onTap: () {
                                // TODO: handle the Polish language selection
                                Navigator.of(context).pop();
                              }
                          ),
                          ListTile(
                              title: const Text('Angielski'),
                              onTap: () {
                                // TODO: handle the English language selection
                                Navigator.of(context).pop();
                              }
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
                                  // Update the language of your app
                                  // You should have a callback to your main.dart file here
                                  // Use a state management solution like Provider, Redux, etc.
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                );
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
              onTap: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete stored data?'),
                      content: Text('This will delete all stored data. Are you sure you want to proceed?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (confirm) {
               //  MyHomePageState().deleteAllContacts(); // W??????ywołanie metody deleteAllContacts
                }
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
                Open.browser(url: 'https://play.google.com/store/apps/details?id=<YOUR_APP_ID>');
              },
            ),

            ListTile(
              leading: Icon(Icons.share_rounded),
              title: Text('Share app'),
              subtitle: Text('TODO: Tap to share app'),
              onTap: () {
                shareApp();

                // Do something when Change Password is tapped
              },
            ),

            ListTile(
              leading: Icon(Icons.comment),
              title: Text('Share feedback'),
              subtitle: Text('Tap to share mail to developer'),
              onTap: () {
                Open.mail(
                    toAddress: "maciwek@gmail.com", subject: "FEEDBACK my_friends", body: "Hello, I writing to express my feedback about my_friends application.");

              },
            ),



            Divider(),
            Text(
              'Help',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.contact_support),
              title: Text('Help & Support'),
              subtitle: Text('Tap to look for frequently asked questions'),
              onTap: () {
                Open.browser(url: "https://duckduckgo.com");
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

