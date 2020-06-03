/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailsPage extends StatelessWidget {
  final List<String> avatars = [
    "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    
  ];

  final String image =
      "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black26),
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Image(
              image: CachedNetworkImageProvider(image),
              fit: BoxFit.cover,
            ),
          ),
          // Gradiente de Gonzalo
          Container(
            height: 300.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 230),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Manuel Antonio",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:
                            /*Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20.0)),
                          child:*/
                            Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 16.0,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "The Green Estafa",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        //),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(32),
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.location_on,
                                            size: 16.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "Parque Nacional Manuel Antonio Puntarenas Province, Quepos",
                                        )
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 4),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.date_range,
                                            size: 16.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "2020-05-05 10p.m",
                                        )
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "\₡ 10000",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  Text(
                                    "i.v.a",
                                    style: TextStyle(fontSize: 14.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      Text(
                        "Description".toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Manuel Antonio National Park, on Costa Rica’s central Pacific coast, encompasses rugged rainforest, white-sand beaches and coral reefs. It’s renowned for its vast diversity of tropical plants and wildlife, from three-toed sloths and endangered white-faced capuchin monkeys to hundreds of bird species. The park’s roughly 680 hectares are crossed with hiking trails, which meander from the coast up into the mountains.",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Interested",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Container(
                                height: 50,
                                child: Stack(
                                  children: [
                                    ...avatars
                                        .asMap()
                                        .map(
                                          (i, e) => MapEntry(
                                            i,
                                            Transform.translate(
                                              offset: Offset(i * 25.0, 0),
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: _buildAvatar(e,
                                                      radius: 25)),
                                            ),
                                          ),
                                        )
                                        .values
                                        .toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 100),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Attend",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Container(
                                height: 50,
                                child: Stack(
                                  children: [
                                    ...avatars
                                        .asMap()
                                        .map(
                                          (i, e) => MapEntry(
                                            i,
                                            Transform.translate(
                                              offset: Offset(i * 25.0, 0),
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: _buildAvatar(e,
                                                      radius: 25)),
                                            ),
                                          ),
                                        )
                                        .values
                                        .toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Theme.of(context).buttonColor,
                          child: Text(
                            "Join event",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CircleAvatar _buildAvatar(String image, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 2,
        backgroundImage: CachedNetworkImageProvider(image),
      ),
    );
  }
}
