import 'package:flutter/material.dart';
import 'package:login_app/model/login_model.dart';
import 'package:login_app/progressHUD.dart';

import 'api/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool hidePassword = false;
  LoginRequestModel requestModel;

  @override
  void initState() {
    requestModel = LoginRequestModel();
    super.initState();
  }

  var isAPICallProcess = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isAPICallProcess,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 100,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          offset: Offset(0, 20),
                          color: Theme.of(context).hintColor.withOpacity(0.2))
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => requestModel.email = input,
                          validator: (value) => !value.contains('@')
                              ? "Enter Valid Email Address"
                              : null,
                          decoration: InputDecoration(
                            hintText: 'Email Address ',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.7),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => requestModel.password = input,
                          validator: (value) => value.length < 3
                              ? "password must be at least 4 characters long"
                              : null,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.7),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 80,
                          ),
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isAPICallProcess = true;
                              });
                              APIService apiService = new APIService();

                              apiService.login(requestModel).then(
                                (value) {
                                  setState(() {
                                    isAPICallProcess = false;
                                  });
                                  if (value.token.isNotEmpty) {
                                    final snackbar = SnackBar(
                                      content: Text('login successful'),
                                    );
                                    scaffoldKey.currentState
                                        .showSnackBar(snackbar);
                                  } else {
                                    final snackbar = SnackBar(
                                      content:
                                          Text('Invalid Email or Password'),
                                    );
                                    scaffoldKey.currentState
                                        .showSnackBar(snackbar);
                                  }
                                },
                              );

                              print(requestModel.tojson());
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }
}
