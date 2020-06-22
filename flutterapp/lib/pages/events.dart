import 'package:flutter/material.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/event_model.dart';
import 'package:flutterapp/widgets/events_list_widget.dart';
import 'package:flutterapp/widgets/prizes_list_widget.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  EventsPage({Key key, @required this.eventModel}) : super(key: key);
  final EventModel eventModel;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<EventModel>.value(
      value:
          EventModel(authentication: authenticaion, dataService: dataService),
      child: Consumer<EventModel>(
        builder: (context, model, _) => EventsPage(
          eventModel: model,
        ),
      ),
    );
  }

  @override
  _EventsPagePageState createState() => _EventsPagePageState();
}

class _EventsPagePageState extends State<EventsPage> {
  EventModel get model => widget.eventModel;

  void _toggleSearchType(EventSearchType searchType) {
    model.toggleSearchType(searchType);
    model.updateData();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: model.updateData,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.search),
            backgroundColor: Theme.of(context).hoverColor,
            title: TextField(
              style: TextStyle(color: Colors.white),
              controller: model.searchController,
              onChanged: model.updateSearch,
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.event)),
                Tab(
                  icon: Icon(Icons.card_giftcard),
                ),
              ],
              onTap: (index) => {
                if (index == 0)
                  {_toggleSearchType(EventSearchType.event)}
                else
                  {_toggleSearchType(EventSearchType.prize)}
              },
            ),
          ),
          body: TabBarView(
            children: [EventList(model: model), PrizesList(model: model)],
          ),
        ),
      ),
    );
  }
}
