import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolie/helper/get_helper.dart';
import 'package:schoolie/widgets/parent/announcementsTiles.dart';

class Announcements extends StatefulWidget {
  final String studentId;

  Announcements({this.studentId});

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  var announcements;

  @override
  void initState() {
    announcements = GetHelper.getData(widget.studentId, 'get_announcements',
        'id'); // get the data using this function from GetHelper class we pass
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
          "Announcements",
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
                    future: announcements,
                    builder: (context, snapshots) {
                      if (!snapshots.hasData || snapshots.data.length == 0) {
                        return Center(
                          child: Text(
                            'No announcements right now',
                            style: GoogleFonts.antic(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshots.data.length,
                        itemBuilder: (context, index) {
                          return AnnouncementTile(
                            headline: snapshots.data[index]['headline'],
                            announcement: snapshots.data[index]['announcement'],
                            name: snapshots.data[index]['name'],
                            date: snapshots.data[index]['date'],
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
