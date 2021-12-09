import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'guru_login.dart';
import 'homepage.dart';
import 'parent_login.dart';
import 'provider/parent.dart';
import 'provider/student.dart';
import 'provider/teacher.dart';
import 'screens/parent/main_parent_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Parent(), // parentProvier
        ),
        ChangeNotifierProvider(
          create: (context) => Student(), // studentparentProvier
        ),
        ChangeNotifierProvider(
          create: (context) => Teacher(), // teacherProvier
        ),
      ],
      child: MaterialApp(
        routes: {
          HomePage.id: (context) => HomePage(),
          GuruLoginPage.id: (context) => GuruLoginPage(),
          ParentLogin.id: (context) => ParentLogin(),
          MainParentPage.routeName: (ctx) => MainParentPage(),
        },
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.id,
      ),
    );
  }
}
