import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementTile extends StatelessWidget {
  final String headline;
  final String name;
  final String announcement;
  final String date;
  AnnouncementTile(
      {this.headline = "",
      this.announcement = "",
      this.name = "",
      this.date = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Text(
                  headline,
                  style: GoogleFonts.alata(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
                Divider(
                  indent: 40,
                  endIndent: 40,
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    announcement,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.yantramanav(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Divider(
                  indent: 40,
                  endIndent: 40,
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'By $name  on $date',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1.5,
        )
      ],
    );
  }
}
