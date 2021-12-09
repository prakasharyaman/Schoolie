import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolie/animation/FadeAnimation.dart';
import 'package:schoolie/helper/get_helper.dart';
import 'package:transparent_image/transparent_image.dart';

class ParentGallery extends StatefulWidget {
  final String studentId;

  ParentGallery({this.studentId});

  @override
  _ParentGalleryState createState() => _ParentGalleryState();
}

class _ParentGalleryState extends State<ParentGallery> {
  List<String> imageList = [];
  List<String> captions = [];
  List<String> teacher = [];

  var imageLinks;
  Future _future;

  @override
  void initState() {
    imageLinks = GetHelper.getData(widget.studentId, 'get_parent_images', 'id');
    // get the data using this function from GetHelper class we pass
    //the student id and name of php file that we use to get data then kind of input for data
    // if you do not understand go and have look at GetHelper class

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        elevation: 10,
        child: Icon(
          Icons.arrow_back,
          size: 40,
        ),
        backgroundColor: Colors.accents[Random().nextInt(Colors.accents.length)]
            .withOpacity(.9),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        centerTitle: true,
        title: Text(
          "Gallery",
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
                    future: imageLinks,
                    builder: (context, snapshots) {
                      if (!snapshots.hasData || snapshots.data.length == 0) {
                        return Center(
                          child: Text(
                            'No image available',
                            style: GoogleFonts.antic(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        );
                      } else {
                        for (int i = 0; i < snapshots.data.length; i++) {
                          imageList.add(
                              'http://192.168.43.145/images_uploads/uploads/${snapshots.data[i]['file_name']}');
                          captions.add(snapshots.data[i]['caption']);
                          teacher.add(snapshots.data[i]['teacher']);
                        }
                      }

                      return new StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => FadeAnimation(
                                          0.5,
                                          AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Center(
                                              child: Text(captions[index]),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            actions: <Widget>[
                                              Image.network(imageList[index]),
                                              Text(
                                                  'Click by ${teacher[index]}'),
                                            ],
                                          ),
                                        ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: imageList[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (index) {
                            return new StaggeredTile.count(
                                1, index.isEven ? 1.2 : 1.8);
                          });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
