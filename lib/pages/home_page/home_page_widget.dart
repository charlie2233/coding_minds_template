import 'package:flutter/cupertino.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: AuthUserStreamWidget(
            builder: (context) => Text(
              'Welcome back, ${currentUserDisplayName}!',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: 25.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                  child: Text("Todays date",style: TextStyle(fontSize: 20),),
              ),
              Center(child: Text(DateTime.now().month.toString()+"/"+DateTime.now().day.toString(),style: TextStyle(fontSize: 20),)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("Schools",style: TextStyle(fontSize: 30),),
                        GestureDetector(
                          onTap: (){
                            print ("Schools");
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.yellow,),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(AssetImage("assets/icons/graduate.png")),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("Competitions",style: TextStyle(fontSize: 30),),
                        GestureDetector(
                          onTap: (){
                            print ("Competitions");
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.yellow,),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(AssetImage("assets/icons/competition.png")),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("Ariticles",style: TextStyle(fontSize: 30),),
                        GestureDetector(
                          onTap: (){
                            print ("Ariticles");
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.yellow,),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(AssetImage("assets/icons/copywriting.png")),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("Calender",style: TextStyle(fontSize: 30),),
                        GestureDetector(
                          onTap: (){
                            print ("Calender");
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.yellow,),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(AssetImage("assets/icons/calendar.png")),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
