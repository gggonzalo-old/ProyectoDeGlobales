import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/create_post_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum FromType { camera, gallery }

class CreatePostPage extends StatefulWidget {
  CreatePostPage({Key key, this.model}) : super(key: key);
  final CreatePostModel model;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<CreatePostModel>.value(
      value: CreatePostModel(
          authentication: authenticaion, dataService: dataService),
      child: Consumer<CreatePostModel>(
        builder: (context, model, _) => CreatePostPage(
          model: model,
        ),
      ),
    );
  }

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  CreatePostModel get model => widget.model;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateData();
    });
  }

  Future getImage(FromType from) async {
    PickedFile pickedFile;

    if (from == FromType.gallery) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }

    File image = File(pickedFile.path);
    model.selectImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Selected image",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 64.0),
                            child: Center(
                              child: DottedBorder(
                                strokeCap: StrokeCap.round,
                                color: Theme.of(context).primaryColorDark,
                                dashPattern: [10, 6],
                                strokeWidth: 3,
                                child: model.image == null
                                    ? Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 32.0,
                                                  right: 32,
                                                  top: 16),
                                              child: Icon(
                                                Icons.image,
                                                size: 150,
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text("Choosed image"),
                                          SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      )
                                    : Container(
                                        child: Image.file(model.image,
                                            fit: BoxFit.fill),
                                        height: 150,
                                        width: double.infinity,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton.icon(
                                  onPressed: () => getImage(FromType.camera),
                                  icon: Icon(Icons.add_a_photo),
                                  label: Text(
                                    "Take a picture",
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  color: Theme.of(context).secondaryHeaderColor,
                                  elevation: 11,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0))),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: RaisedButton.icon(
                                  onPressed: () => getImage(FromType.gallery),
                                  icon: Icon(
                                    Icons.photo_library,
                                  ),
                                  label: Text("Gallery"),
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  color: Theme.of(context).secondaryHeaderColor,
                                  elevation: 11,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          style: TextStyle(fontSize: 16),
                          onChanged: model.updateDescription,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                              hintText: 'Type a description for your photo',
                              labelText: 'Description(Optional)',
                              suffixStyle:
                                  const TextStyle(color: Colors.green)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Tag",
                          style: TextStyle(fontSize: 18),
                        ),
                        model.userTags.isEmpty
                            ? Center(
                                child: Text("Join an event to unlock a tag."),
                              )
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                      child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: model.dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    underline: Container(
                                      height: 2,
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                    ),
                                    onChanged: (String newValue) {
                                      model.updateDropDownValue(newValue);
                                    },
                                    items: model.userTags
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RaisedButton.icon(
                            icon: Icon(
                              Icons.send,
                            ),
                            label: Text(
                              "Create post",
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            color: Theme.of(context).buttonColor,
                            onPressed:
                                model.dropdownValue != "" && model.image != null
                                    ? model.createPost
                                    : null,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
      ),
    );
  }
}
