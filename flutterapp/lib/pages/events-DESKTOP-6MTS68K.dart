import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          decoration: InputDecoration(hintText: "Search an event..."),
          controller: controller,
          cursorColor: Colors.white,
        ),
      ),
      body: ListView(
        children: List.generate(
          3,
          (index) => card(context),
        ),
      ),
    );
  }

  Widget card(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExpansionTile(
              title: Text('Birth of Universe', style: TextStyle()),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Big Bang',
                    ),
                  ],
                ),
                Text('Birth of the Sun'),
                Text('Earth is Born'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
