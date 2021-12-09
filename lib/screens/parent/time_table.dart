import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:schoolie/helper/multiple_helper.dart';

class TimeTableParent extends StatefulWidget {
  @override
  _TimeTableParentState createState() => _TimeTableParentState();
}

class _TimeTableParentState extends State<TimeTableParent> {
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
    timetables = GetMultiHelper.getData(
        'institutions',
        'get_student_timetable',
        'a',
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
          "Time Table",
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
                            'No time table available',
                            style: GoogleFonts.antic(
                                fontWeight: FontWeight.bold, fontSize: 30),
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
                            child: RoutineCard(
                              classTopic:
                                  capitalize(snapshots.data[index]['subject']),
                              classType: capitalize(
                                  snapshots.data[index]['classType']),
                              subject:
                                  capitalize(snapshots.data[index]['subject']),
                              professor:
                                  capitalize(snapshots.data[index]['teacher']),
                              time: capitalize(snapshots.data[index]['time']),
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

class TimeTableCard extends StatelessWidget {
  final String classTopic;
  final String classType;
  final String subject;
  final String time;
  final String teacher;
  TimeTableCard(
      {this.classTopic, this.classType, this.subject, this.time, this.teacher});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.class_,
                      size: 50,
                    ),
                  ],
                ),
                Column(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
