import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/blocs/login_bloc.dart';
import 'package:flutterapp/pages/bottom_navigation.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    return Provider<LogInBloc>(
      create: (_) => LogInBloc(),
      child: LoginPage(),
    );
  }

  Future<void> _signInGoogle(BuildContext context) async {
    final bloc = Provider.of<LogInBloc>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final authentication =
          Provider.of<AuthenticationBase>(context, listen: false);
      authentication.signInGoogle();
    } catch (e) {
      print(e.toString());
    } finally {
      bloc.setIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LogInBloc>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(context),
          StreamBuilder<bool>(
              stream: bloc.isLoadingStream,
              initialData: false,
              builder: (context, snapshot) {
                return ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height / 1.5
                          : 275,
                      child: Center(
                          child: _buildLogInInputs(context, snapshot.data)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height / 8
                          : 30,
                    ),
                    _buildThirdPartySignIn(context, snapshot.data),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: RotatedBox(
        quarterTurns: 2,
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [Colors.teal, Colors.green],
              [Colors.white24, Colors.teal[600]],
              [Colors.green, Colors.teal[300]],
              [Colors.teal, Colors.green[100]]
            ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.20, 0.23, 0.25, 0.30],
            blur: MaskFilter.blur(BlurStyle.solid, 10),
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
          waveAmplitude: 0,
          size: Size(
            double.infinity,
            double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildLogInInputs(BuildContext context, bool isLoading) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 28.0)),
        Card(
          margin: EdgeInsets.only(left: 30, right: 30, top: 30),
          elevation: 11,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black26,
              ),
              hintText: "Username",
              hintStyle: TextStyle(color: Colors.black26),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          elevation: 11,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black26,
              ),
              suffixIcon: Icon(
                Icons.remove_red_eye,
                color: Colors.black26,
              ),
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.black26,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
            ),
            obscureText: true,
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            color: Colors.green[700],
            onPressed: () {},
            elevation: 11,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
            child: Text("Login", style: TextStyle(color: Colors.white70)),
          ),
        ),
      ],
    );
  }

  Widget _buildThirdPartySignIn(BuildContext context, bool isLoading) {
    return Center(
      child: Column(
        children: <Widget>[
          Text("or, connect with"),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text("Facebook"),
                  textColor: Colors.white,
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  onPressed: isLoading ? null : () {},
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text("Google"),
                  textColor: Colors.white,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          _signInGoogle(context);
                        },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
