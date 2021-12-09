import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:schoolie/helper/multiple_helper.dart';

class Events extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Events> {
  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  var timetables;
  @override
  void initState() {
    timetables = GetMultiHelper.getData('institutions', 'get_events', 'a',
        6); // get the data using this function from GetHelper class we pass
    //the student id and name of php file that we use to get data then kind of input for data
    // if you do not understand go and have look at GetHelper class

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        centerTitle: true,
        title: Text(
          "Events",
          style: GoogleFonts.antic(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  child: FutureBuilder(
                    future: timetables,
                    builder: (context, snapshots) {
                      if (!snapshots.hasData || snapshots.data.length == 0) {
                        return Center(
                          child: Text(
                            'No events available',
                            style: GoogleFonts.pacifico(
                                fontWeight: FontWeight.bold, fontSize: 50),
                          ),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshots.data.length,
                        itemBuilder: (context, index) {
                          ScreenUtil.init(
                            context,
                            width: ScreenUtil.screenWidth,
                            height: ScreenUtil.screenHeight,
                            allowFontScaling: true,
                          );
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EventCard(
                              event: capitalize(snapshots.data[index]['event']),
                              time: capitalize(
                                  snapshots.data[index]['date_and_time']),
                              secondaryColor: SchoolToolkitColors.lighterGrey,
                              primaryColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                            ),
                          );
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
