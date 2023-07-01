import 'package:flutter/material.dart';

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
  int relationshipValue = 0;

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
          'VIEW CONTACT',
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
                      Text(
                        '${widget.firstName} ${widget.lastName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Rola: ${widget.role}',
                        style: TextStyle(fontSize: 16),
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
              readOnly: true,
              initialValue: widget.description,
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
    );
  }
}
