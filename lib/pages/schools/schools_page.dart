import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class schools_page extends StatefulWidget {
  const schools_page({super.key});

  @override
  State<schools_page> createState() => _schools_pageState();
}
class _schools_pageState extends State<schools_page> {
  late List<dynamic> schoolsList;
  Future<String> readJson() async{
    final String response = await rootBundle.loadString("assets/school.json");
    final data = await json.decode(response);
    schoolsList = data;
    return "data";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(future: readJson(), builder: (context,snapshot){
          if (snapshot.hasData){
            return Card(
              child: Column(children: [
                Text(
                  schoolsList[0]["University Rank"].toString(),
                ),
                Text(
                  schoolsList[0]["Name of University"].toString(),
                ),
                Text(
                  schoolsList[0]["Location"].toString(),
                ),
                Text(
                  schoolsList[0]["OverAll Score"].toString(),
                ),
              ],),
            );
          }else{
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
