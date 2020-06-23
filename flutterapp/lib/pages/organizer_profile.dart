import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/organizer.dart';
import 'package:flutterapp/pages/event_details.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/organizer_profile_model.dart';
import 'package:provider/provider.dart';

class OrganizerProfilePage extends StatefulWidget {
  OrganizerProfilePage({Key key, @required this.model}) : super(key: key);
  final OrganizerProfileModel model;
  static Widget create(BuildContext context, Organizer organizer) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<OrganizerProfileModel>.value(
      value: OrganizerProfileModel(
          authentication: authenticaion,
          dataService: dataService,
          organizer: organizer),
      child: Consumer<OrganizerProfileModel>(
        builder: (context, model, _) => OrganizerProfilePage(
          model: model,
        ),
      ),
    );
  }

  @override
  _OrganizerProfilePageState createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  OrganizerProfileModel get model => widget.model;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateData();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: model.isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: 380,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 380,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "https://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg"),
                          fit: BoxFit.fill),
                    ),
                    foregroundDecoration:
                        BoxDecoration(color: Colors.green.withOpacity(0.9)),
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    const SizedBox(height: 90),
                    _buildAvatar(model.organizer.imageUrl),
                    const SizedBox(height: 10.0),
                    Text(
                      model.organizer.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 32.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                model.organizer.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Events",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: model.organizer.events.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _buildEventCard(
                              context, model.organizer.events[index]);
                        },
                      ),
                    ),
                  ],
                )
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

  Widget _buildEventCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage.create(context, event),
          ),
        )
      },
      child: Container(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(event.imageUrl),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10.0)),
              foregroundDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                event.name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
