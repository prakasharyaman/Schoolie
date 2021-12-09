import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:schoolie/animation/FadeAnimation.dart';
import 'package:schoolie/helper/multiple_helper.dart';
import 'package:schoolie/provider/parent.dart';
import 'package:schoolie/provider/student.dart';
import 'package:schoolie/screens/common/announcements.dart';
import 'package:schoolie/screens/parent/assignments.dart';
import 'package:schoolie/screens/parent/events.dart';
import 'package:schoolie/screens/parent/gallery.dart';
import 'package:schoolie/screens/parent/notice_board.dart';
import 'package:schoolie/screens/parent/parentmessages.dart';
import 'package:schoolie/screens/parent/tasks_page.dart';
import 'package:schoolie/screens/parent/time_table.dart';

class ScreenSize {
  static const double width = 414.0;
  static const double height = 896.0;
}

class MainParentPage extends StatefulWidget {
  static const routeName = '/main-parent-page';

  @override
  _MainParentPageState createState() => _MainParentPageState();
}

class _MainParentPageState extends State<MainParentPage> {
  static DateTime date = DateTime.now();
  static String _dateFormat = DateFormat('yMMMd').format(date);
  ScrollController _controller;
  var timetables;
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];

  ParentInf getParentInfo;
  StudentInf getStudentInfo;
  String parentName;
  String parentAddress;
  String parentNumber;
  String studentId;
  String schoolId;

  @override
  void initState() {
    timetables = GetMultiHelper.getData(
        'institutions', 'get_student_timetable', 'a', 6); //
    super.initState();
    // we use this method to avoid crashing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Student>(context, listen: false)
          .getInfWithID(studentId)
          .then((state) {
        // if we get the data properly
        if (state) {
          // if true get the student data
          getStudentInfo =
              Provider.of<Student>(context, listen: false).getStudentInf();
        } else {
          print('Something wrong just happened');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ScreenUtil() == null) {
      ScreenUtil.init(
        context,
        width: ScreenSize.width,
        height: ScreenSize.height,
        allowFontScaling: true,
      );
    }
    // get parent data
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentAddress = getParentInfo.address;
    parentNumber = getParentInfo.number;
    studentId = getParentInfo.studentID;
    schoolId = getParentInfo.schoolID;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: ParentDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: SchoolToolkitColors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (value) {
            if (value == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tasks(),
                ),
              );
            } else if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Assignments()),
              );
            } else if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ParentGallery();
                }),
              );
            } else {
              print('bottom navigation malfunction');
            }
            // Respond to item press.
          },
          items: [
            BottomNavigationBarItem(
              title: Text('Tasks'),
              icon: Icon(Icons.toc),
            ),
            BottomNavigationBarItem(
              title: Text('Study Material'),
              icon: Icon(Icons.assignment),
            ),
            BottomNavigationBarItem(
              title: Text('Gallery'),
              icon: Icon(Icons.image),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: SchoolToolkitColors.blue,
          title: Text(
            'Home',
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ParentMessages(studentsSection: '6'),
                    ),
                  );
                },
                child: Icon(
                  Icons.message,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Time Table',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SchoolToolkitColors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                height: MediaQuery.of(context).size.height * .21,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimeTableParent()),
                    );
                  },
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

                      return Scrollbar(
                        controller: _controller,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshots.data.length,
                          itemBuilder: (context, index) {
                            ScreenUtil.init(
                              context,
                              width: ScreenUtil.screenWidth * 1.3,
                              height: ScreenUtil.screenHeight,
                              allowFontScaling: true,
                            );
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: RoutineCard(
                                classTopic: snapshots.data[index]['subject']
                                    .toString()
                                    .toUpperCase(),
                                classType: snapshots.data[index]['classType']
                                    .toString()
                                    .toUpperCase(),
                                subject: snapshots.data[index]['subject']
                                    .toString()
                                    .toUpperCase(),
                                professor: snapshots.data[index]['teacher']
                                    .toString()
                                    .toUpperCase(),
                                time: snapshots.data[index]['time']
                                    .toString()
                                    .toUpperCase(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Card(
                          shadowColor: SchoolToolkitColors.blue,
                          elevation: 30,
                          child: Column(
                            children: [
                              Text(
                                'Attendance',
                                style: TextStyle(
                                    color: SchoolToolkitColors.blue,
                                    fontSize: 18),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          _dateFormat,
                                          style: TextStyle(
                                              color: SchoolToolkitColors.blue,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Not Marked',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        color:
                                                            SchoolToolkitColors
                                                                .blue),
                                                  ),
                                                  Text(
                                                    '2',
                                                    style: TextStyle(
                                                        color:
                                                            SchoolToolkitColors
                                                                .blue),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Present',
                                                    style: TextStyle(
                                                        color:
                                                            SchoolToolkitColors
                                                                .blue),
                                                  ),
                                                  Text(
                                                    '1',
                                                    style: TextStyle(
                                                        color:
                                                            SchoolToolkitColors
                                                                .blue),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Absent',
                                                    style: TextStyle(
                                                        color:
                                                            SchoolToolkitColors
                                                                .blue),
                                                  ),
                                                  Text(
                                                    '1',
                                                    style: TextStyle(
                                                        color:
                                                            SchoolToolkitColors
                                                                .blue),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CircularPercentIndicator(
                                      radius: 120.0,
                                      lineWidth: 12.0,
                                      animation: true,
                                      percent: 0.7,
                                      center: new Text(
                                        "70.0%",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: SchoolToolkitColors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: SchoolToolkitColors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.create,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Exams',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: SchoolToolkitColors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.markunread_mailbox,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                Text(
                                                  'Marks',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: SchoolToolkitColors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.announcement,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Announcements',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: SchoolToolkitColors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.event,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                Text(
                                                  'Events',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //all the exam marks,announcemts,events
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            //just a simple container to ensure that the icons dont take extra space
                          ],
                        ),
                      )
                    ],
                    // primary: false,
                    // children: <Widget>[
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => Announcements(
                    //                   studentId: studentId,
                    //                 )),
                    //       );
                    //     },
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       color: Colors.blue[100],
                    //       elevation: 10,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Icon(
                    //                 Icons.announcement,
                    //                 size: 50,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Announcements',
                    //               style: GoogleFonts.antic(
                    //                 textStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => TimeTableParent()),
                    //       );
                    //     },
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15.0),
                    //       ),
                    //       color: Colors.blue[100],
                    //       elevation: 10,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Icon(
                    //                 Icons.schedule,
                    //                 size: 50,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Time Table',
                    //               style: GoogleFonts.antic(
                    //                 textStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => Events()),
                    //       );
                    //     },
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15.0),
                    //       ),
                    //       color: Colors.blue[100],
                    //       elevation: 10,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Icon(
                    //                 Icons.event,
                    //                 size: 50,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Events',
                    //               style: GoogleFonts.antic(
                    //                 textStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => NoticeBoard()),
                    //       );
                    //     },
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15.0),
                    //       ),
                    //       color: Colors.blue[100],
                    //       elevation: 10,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Icon(
                    //                 Icons.dashboard,
                    //                 size: 50,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Notice Board',
                    //               style: GoogleFonts.antic(
                    //                 textStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => Assignments()),
                    //       );
                    //     },
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15.0),
                    //       ),
                    //       color: Colors.blue[100],
                    //       elevation: 10,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Icon(
                    //                 Icons.assignment,
                    //                 size: 50,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Study Material',
                    //               style: GoogleFonts.antic(
                    //                 textStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ParentGallery()),
                    //       );
                    //     },
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15.0),
                    //       ),
                    //       color: Colors.blue[100],
                    //       elevation: 10,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Icon(
                    //                 Icons.image,
                    //                 size: 50,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Images',
                    //               style: GoogleFonts.antic(
                    //                 textStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   CardItem(
                    //       desc: 'Student Inf',
                    //       img: 'assets/images/student-icon.png',
                    //       color: Color.fromRGBO(125, 180, 123, 1),
                    //       function: () => showStudentInfDialog(
                    //           getStudentInfo.name,
                    //           getStudentInfo.grade,
                    //           getStudentInfo.address,
                    //           getStudentInfo.dateOfBirth)),
                    //   CardItem(
                    //     desc: 'Feedback',
                    //     img: 'assets/images/child-feedback-icon.png',
                    //     color: Color.fromRGBO(75, 76, 96, 1),
                    //     function: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => StudentFeedback(
                    //                   studentId: studentId,
                    //                 )),
                    //       );
                    //     },
                    //   ),
                    //   CardItem(
                    //       desc: 'Classes',
                    //       img: 'assets/images/class-icon.png',
                    //       color: Color.fromRGBO(120, 99, 101, 1),
                    //       function: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Classes(
                    //                     studentId: studentId,
                    //                   )),
                    //         );
                    //       }),
                    //   CardItem(
                    //     desc: 'Time Table',
                    //     img: 'assets/images/time-table-icon.png',
                    //     color: Color.fromRGBO(95, 78, 112, 1),
                    //     function: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => TablePage(
                    //                   studentGrade: getStudentInfo.grade,
                    //                 )),
                    //       );
                    //     },
                    //   ),
                    //   CardItem(
                    //     desc: 'Activities',
                    //     img: 'assets/images/activites-icon.png',
                    //     color: Color.fromRGBO(78, 94, 112, 1),
                    //     function: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => Activities(
                    //                   studentId: studentId,
                    //                 )),
                    //       );
                    //     },
                    //   ),
                    //   CardItem(
                    //     desc: 'Medication',
                    //     img: 'assets/images/medication-icon.png',
                    //     color: Color.fromRGBO(112, 78, 95, 1),
                    //     function: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => Medication(
                    //             studentId: studentId,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    //   CardItem(
                    //     desc: 'Emergency',
                    //     img: 'assets/images/emergency-people-icon.png',
                    //     color: Color.fromRGBO(231, 75, 75, 1),
                    //     function: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => Emergency(
                    //                   studentId: studentId,
                    //                 )),
                    //       );
                    //     },
                    //   ),
                    //   CardItem(
                    //       desc: 'Fees',
                    //       img: 'assets/images/fees-icon.png',
                    //       color: Color.fromRGBO(75, 96, 82, 1),
                    //       function: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Fees(
                    //                     studentId: studentId,
                    //                   )),
                    //         );
                    //       }),
                    //   CardItem(
                    //     desc: 'Send complaint',
                    //     img: 'assets/images/complaint-icon.png',
                    //     color: Color.fromRGBO(70, 71, 60, 1),
                    //     function: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ComplantPage(
                    //                   schoolId: schoolId,
                    //                 )),
                    //       );
                    //     },
                    //   ),
                    //   CardItem(
                    //       desc: 'log Out',
                    //       img: 'assets/images/logout-icon.png',
                    //       color: Color.fromRGBO(154, 80, 80, 1),
                    //       function: () {
                    //         Provider.of<Parent>(context).logOut();
                    //         Provider.of<Student>(context).logOut();
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => ParentLogin()),
                    //         );
                    //       }),
                    // ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showStudentInfDialog(
      String name, String grade, String address, String dateOfBirth) {
    showDialog(
        context: context,
        builder: (_) => FadeAnimation(
              0.5,
              AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: Text('Student Information'),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Name : $name',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'grade : $grade',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Address : $address',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Date Of Birth : $dateOfBirth',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                ],
              ),
            ));
  }
}

class ParentDrawer extends StatelessWidget {
  const ParentDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // space to fit everything.
      child: Container(
        padding: EdgeInsets.only(top: 30),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  // height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: SchoolToolkitColors.blue, width: 2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ClipOval(
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/simple.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Siddhartha joshi',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            DrawerTile(
              title: 'Announcements',
              icon: Icon(
                Icons.announcement,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Announcements()),
                );
              },
            ),
            DrawerTile(
              title: 'Time Table',
              icon: Icon(
                Icons.schedule,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeTableParent()),
                );
              },
            ),
            DrawerTile(
              title: 'Events',
              icon: Icon(
                Icons.event,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Events()),
                );
              },
            ),
            DrawerTile(
              title: 'Notice Board',
              icon: Icon(
                Icons.dashboard,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Study Material',
              icon: Icon(
                Icons.assignment,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Assignments()),
                );
              },
            ),
            DrawerTile(
              title: 'Gallery',
              icon: Icon(
                Icons.image,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Marks',
              icon: Icon(
                Icons.library_books,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Attendance',
              icon: Icon(
                Icons.perm_contact_calendar,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Fee',
              icon: Icon(
                Icons.attach_money,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Teacher Feedback',
              icon: Icon(
                Icons.contact_mail,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Tasks',
              icon: Icon(
                Icons.toc,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Calender',
              icon: Icon(
                Icons.calendar_today,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Videos',
              icon: Icon(
                Icons.video_library,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Profile',
              icon: Icon(
                Icons.perm_identity,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
            DrawerTile(
              title: 'Bus route',
              icon: Icon(
                Icons.directions_bus,
                color: SchoolToolkitColors.blue,
              ),
              function: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticeBoard()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final Icon icon;
  final Function function;
  final String title;

  const DrawerTile({Key key, this.icon, this.function, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text('$title'), leading: icon, onTap: function);
  }
}

//child: Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//SizedBox(
//height: 50,
//),
//Center(
//child: FadeAnimation(
//1.3,
//Text(
//"Mr, $parentName",
//style: GoogleFonts.antic(
//textStyle: TextStyle(
//color: Colors.white,
//fontWeight: FontWeight.bold),
//fontSize: 25,
//),
//))),
//Center(
//child: FadeAnimation(
//1.3,
//Text(
//"Address : $parentAddress",
//style: GoogleFonts.asar(
//textStyle: TextStyle(
//color: Colors.white,
//fontWeight: FontWeight.bold),
//fontSize: 20,
//),
//))),
//Center(
//child: FadeAnimation(
//1.3,
//Text(
//"Phone Number : $parentNumber",
//style: GoogleFonts.asar(
//textStyle: TextStyle(
//color: Colors.white,
//fontWeight: FontWeight.bold),
//fontSize: 20,
//),
//))),
//],
//),
