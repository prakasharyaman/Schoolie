import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class ExpandedNotices extends StatelessWidget {
  final String title;
  final String text;
  final String date;

  ExpandedNotices(
      {@required this.title, @required this.text, @required this.date});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          elevation: 10,
          child: Icon(
            Icons.arrow_back,
            size: 40,
          ),
          backgroundColor: Colors
              .accents[Random().nextInt(Colors.accents.length)]
              .withOpacity(.9),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue[50],
          title: Text(
            '$title',
            style: GoogleFonts.alata(
                textStyle: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            )),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabelCard(
                    label: '$text',
                    color: Colors
                        .accents[Random().nextInt(Colors.accents.length)]
                        .withOpacity(.1),
                    textStyle: GoogleFonts.abel(
                      textStyle: TextStyle(
                          fontSize: 25,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '$date',
                      style: GoogleFonts.strait(
                        textStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
