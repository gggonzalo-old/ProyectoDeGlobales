import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(children: [Container(), Container()]),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: Icon(Icons.search),
      title: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
      ),
      bottom: TabBar(tabs: [
        Tab(icon: Icon(Icons.people)),
        Tab(icon: Icon(Icons.location_city)),
      ]),
    );
  }
}
