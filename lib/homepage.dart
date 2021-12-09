import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schoolie/guru_login.dart';
import 'package:schoolie/parent_login.dart';

import 'animation/FadeAnimation.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "School Link",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Connect to your awesome school",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      )),
                ],
              ),
              FadeAnimation(
                  1.6,
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/simple.png'))),
                  )),
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.pushNamed(context, GuruLoginPage.id);
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xFFF7DDCF),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "I am a teacher",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xFFF7DDCF)),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.6,
                      Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.pushNamed(context, ParentLogin.id);
                          },
                          color: Color(0xFFF7DDCF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "I am a parent",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
