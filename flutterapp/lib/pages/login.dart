import 'package:flutter/material.dart';
import 'package:flutterapp/view_models/log_in_model.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key key, @required this.model}) : super(key: key);
  final LogInModel model;

  static Widget create(BuildContext context) {
    final authentication =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<LogInModel>(
      create: (_) => LogInModel(authenticationBase: authentication),
      child: Consumer<LogInModel>(
        builder: (context, model, _) => LogInPage(
          model: model,
        ),
      ),
    );
  }

  @override
  _LogInPage createState() => _LogInPage();
}

class _LogInPage extends State<LogInPage> {
  LogInModel get model => widget.model;

  Future<void> _signInWithGoogle() async {
    try {
      model.signInGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(context),
          ListView(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain),
                ),
              ),
              _buildThirdPartySignIn(context),
          SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      height: 200,
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

  Widget _buildThirdPartySignIn(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset("assets/images/facebook-logo.png"),
                        Text("Sign in with Facebook", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: model.isLoading ? null : () {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset("assets/images/google-logo.png"),
                        Text("Sign in with Google", style: TextStyle(fontSize: 18),),
                      ],
                    ),
                    textColor: Colors.black,
                    color: Colors.white,
                    onPressed: model.isLoading
                        ? null
                        : () {
                            _signInWithGoogle();
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
