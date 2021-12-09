import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolie/animation/FadeAnimation.dart';
import 'package:schoolie/constants.dart';
import 'package:schoolie/helper/multiple_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Assignments extends StatefulWidget {
  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  var studyMaterial;
  @override
  void initState() {
    studyMaterial = GetMultiHelper.getData(
        'institutions',
        'get_study_material',
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        backgroundColor: Colors.blue[50],
        centerTitle: true,
        title: Text(
          "Study Material",
          style: GoogleFonts.antic(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue[50].withOpacity(.2),
              Colors.blue[50].withOpacity(.5)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                child: FutureBuilder(
                  future: studyMaterial,
                  builder: (context, snapshots) {
                    if (!snapshots.hasData || snapshots.data.length == 0) {
                      return Center(
                        child: Text(
                          'No material available',
                          style: TextStyle(
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
                          child: AssignmentDownloadCard(
                            title: snapshots.data[index]['title'],
                            subject: snapshots.data[index]['subject'],
                            fileid: snapshots.data[index]['fileid'],
                            dateTime: snapshots.data[index]['date'].toString(),
                            teacher: snapshots.data[index]['teacher'],
                          ),

//                            AssignmentDownloadCard(),
                        );
                      },
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class AssignmentDownloadCard extends StatefulWidget {
  final String title;
  final String subject;
  final String fileid;
  final String dateTime;
  final String teacher;

  const AssignmentDownloadCard({
    this.title,
    this.subject,
    this.fileid,
    this.dateTime,
    this.teacher,
  });

  @override
  _AssignmentDownloadCardState createState() => _AssignmentDownloadCardState();
}

class _AssignmentDownloadCardState extends State<AssignmentDownloadCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kContainerdecoration,
      child: FadeAnimation(
          .1,
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            elevation: 8,
            borderOnForeground: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '${widget.title}',
                    style:
                        kDownloadMaterialCardTextSTyle.copyWith(fontSize: 20),
                  ),
                ),
                Divider(
                  height: .1,
                  indent: 30,
                  endIndent: 30,
                  thickness: .5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Icon(
                            Icons.assignment,
                            size: 50,
                            color: Colors.blue[100].withOpacity(.6),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Subject: ${widget.subject}',
                                style: kDownloadMaterialCardTextSTyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Teacher: ${widget.teacher}',
                                style: kDownloadMaterialCardTextSTyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Date: ${widget.dateTime}',
                                style: kDownloadMaterialCardTextSTyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                            color: Colors.blue[50],
                            child: Row(
                              children: [
                                Text(
                                  'Download',
                                  style: kDownloadMaterialCardTextSTyle,
                                ),
                                Icon(
                                  Icons.file_download,
                                  color: Colors.blue[100].withOpacity(.7),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              String id = widget.fileid.toString();
                              String url =
                                  'http://192.168.43.145/blob_upload/download.php?id=$id';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
