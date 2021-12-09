import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolie/helper/multiple_helper.dart';

class ParentMessages extends StatefulWidget {
  final String studentsSection;

  ParentMessages({@required this.studentsSection});

  @override
  _ParentMessagesState createState() => _ParentMessagesState();
}

class _ParentMessagesState extends State<ParentMessages> {
  var announcements;

  @override
  void initState() {
    announcements = GetMultiHelper.getData('institutions', 'get_messages', 'a',
        6); // get// the data using this function from GetHelper class we pass
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
          "Messages",
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
                            'No new messages right now',
                            style: GoogleFonts.antic(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshots.data.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            headline: snapshots.data[index]['headline'],
                            message: snapshots.data[index]['message'],
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

class MessageTile extends StatelessWidget {
  final String headline;
  final String name;
  final String message;
  final String date;
  MessageTile(
      {this.headline = "", this.message = "", this.name = "", this.date = ""});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    headline,
                    style: GoogleFonts.alata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Divider(
                  indent: 40,
                  endIndent: 40,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    message,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.signika(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Divider(
                  indent: 40,
                  endIndent: 40,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'By $name  on $date',
            textAlign: TextAlign.left,
            style: GoogleFonts.satisfy(
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
