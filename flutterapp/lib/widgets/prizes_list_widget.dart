import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/prize.dart';
import 'package:flutterapp/view_models/event_model.dart';

class PrizesList extends StatefulWidget {
  PrizesList({Key key, @required this.model}) : super(key: key);
  final EventModel model;

  @override
  _PrizesListState createState() => _PrizesListState();
}

class _PrizesListState extends State<PrizesList> {
  EventModel get model => widget.model;
  @override
  Widget build(BuildContext context) {
    return model.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : model.prizes.isEmpty
            ? Scaffold(
                body: Center(
                  child: Text("No prizes found"),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: model.prizes.length,
                itemBuilder: (context, index) {
                  return _buildPrize(context, model.prizes[index]);
                },
              );
  }

  Widget _buildPrize(BuildContext context, Prize prize) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: CachedNetworkImageProvider(prize.imageUrl),
                        fit: BoxFit.fill,
                      ),
                      height: 300,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Theme.of(context).cardColor,
                        child: Text(prize.cost.toString()),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prize.name,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(prize.description),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text("Claim"),
                          onPressed: () async => {
                            await model.claimPrize(prize),
                            model.prizeClaimedSuccess
                                ? _showClaimedSucessDialog(context, prize)
                                : _showClaimedFailedDialog(context)
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showClaimedSucessDialog(BuildContext context, Prize prize) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("The prize has been claimed."),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(prize.qrUrl),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showClaimedFailedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(
              "There has been an error claiming this prize, make sure you have enough points to do so. "),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
