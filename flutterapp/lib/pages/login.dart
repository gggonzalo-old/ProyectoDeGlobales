import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/view_models/log_in_model.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key key, @required this.model}) : super(key: key);
  final LogInModel model;

  static Widget create(BuildContext context) {
    final authentication = Provider.of<AuthenticationBase>(context);
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  LogInModel get model => widget.model;

  Future<void> _signWithEmailAndPassword() async {
    try {
      model.signWithEmailAndPassword();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      model.signInGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingCompleted() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(context),
          ListView(
            children: <Widget>[
              Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height / 1.5
                        : 275,
                child: Center(child: _buildLogInInputs(context)),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height / 8
                        : 30,
              ),
              _buildThirdPartySignIn(context),
            ],
          ),
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

  Widget _buildLogInInputs(BuildContext context) {
    // utilizar primary and second text
    //
    //
    ///
    //
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
        _buildEmailTextInput(),
        _buildPasswordTextInput(),
        _buildLoginButton(),
      ],
    );
  }

  Container _buildLoginButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.green[700],
        onPressed: model.canSubmit ? _signWithEmailAndPassword : null,
        elevation: 11,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        child: Text("Login", style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildEmailTextInput() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
      elevation: 11,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        focusNode: _emailFocusNode,
        onEditingComplete: () {
          _emailEditingCompleted();
        },
        textInputAction: TextInputAction.next,
        onChanged: model.updateEmail,
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
          errorText: model.emailErrorText,
        ),
      ),
    );
  }

  Widget _buildPasswordTextInput() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: TextField(
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onChanged: model.updatePassword,
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
          errorText: model.passwordErrorText,
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildThirdPartySignIn(BuildContext context) {
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
                  onPressed: model.isLoading ? null : () {},
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
                  onPressed: model.isLoading
                      ? null
                      : () {
                          _signInWithGoogle();
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
