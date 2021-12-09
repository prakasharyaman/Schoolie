import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animation/FadeAnimation.dart';
import 'provider/parent.dart';
import 'screens/parent/parentdashboard.dart';

class ParentLogin extends StatefulWidget {
  static const String id = 'parent_login';

  @override
  _ParentLoginState createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // the key for the form
  TextEditingController user =
      new TextEditingController(); // the controller for the usename that user will put in the text field
  TextEditingController pass =
      new TextEditingController(); // the controller for the password that user will put in the text field

  int selectedRadio = 1; // variable for radiobutton

// show alert function we will use if the user entered a wrong user name or password
  showAlert(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => ParentLogin()));
                },
              )
            ],
          );
        });
  }

// we will use CircularProgressIndicator while logging in
  showLoadingProgress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )),
          );
        });
  }

  // login function
  _login() async {
    if (_formKey.currentState.validate()) {
      // check if all the conditionsthe we put on validators are right
      print('hurray');
      showLoadingProgress(); // show CircularProgressIndicator

      Provider.of<Parent>(context, listen: false)
          .loginParentAndGetInf(user.text, pass.text)
          .then((state) {
        // pass username and password that user entered

        if (state) {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new MainParentPage()));
          // if the function returned true

//          Navigator.of(context).pushNamed(
//              MainParentPage.routeName); // go to the Main page for parent
        } else {
          showAlert('Error',
              'You Entered Wrong username or password'); // otherwise show an Alert
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Hello Parent",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Log in to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // FadeAnimation(f
                    //     1, makeInput(label: "School Code", controller: user)),
                    FadeAnimation(
                        1.5,
                        makeInput(
                            label: "Registration No.",
                            obscureText: false,
                            controller: user)),
                    FadeAnimation(
                        1,
                        makeInput(
                            label: "Password",
                            obscureText: true,
                            controller: pass)),
                  ],
                ),
              ),
              FadeAnimation(
                  1.5,
                  Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        _login();
                      },
                      color: Color(0xFFF7DDCF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
              FadeAnimation(
                  1.5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Not a Parent? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Go Back",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {label, obscureText = false, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (value) {
            //check if the username is not less than two characters
            if (value.length < 2) {
              return '$value length not long enough';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
