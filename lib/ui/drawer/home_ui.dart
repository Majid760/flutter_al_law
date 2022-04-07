import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Al-Law Features',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.white,
              elevation: 2,
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
                child: Container(
                  // height: 140,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.ClientsEvent);
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Icon(
                                      Icons.supervisor_account,
                                      color: Colors.deepOrange,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Clients',
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.CasesEvent);
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Icon(
                                      Icons.book,
                                      // Icons.article,
                                      color: Colors.indigo,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Cases',
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: InkWell(
                          //     onTap: () {},
                          //     child: Container(
                          //       padding: EdgeInsets.all(6),
                          //       decoration: BoxDecoration(
                          //         border: Border(
                          //           bottom: BorderSide(
                          //             color: Colors.black12,
                          //             width: 0.5,
                          //           ),
                          //         ),
                          //       ),
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           SizedBox(
                          //             height: 8,
                          //           ),
                          //           Icon(
                          //             Icons.calendar_today,
                          //             color: Colors.deepPurple,
                          //             size: 40,
                          //           ),
                          //           SizedBox(
                          //             height: 3,
                          //           ),
                          //           Text(
                          //             'Calendar',
                          //           ),
                          //           SizedBox(
                          //             height: 8,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<DrawerBloc>(context)
                                    .add(DrawerEvents.SchedulesEvent);
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Icon(
                                      Icons.schedule,
                                      color: Colors.teal,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Schedule',
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: InkWell(
                          //     onTap: () {
                          //       BlocProvider.of<DrawerBloc>(context)
                          //           .add(DrawerEvents.EvidencesEvent);
                          //     },
                          //     child: Container(
                          //       padding: EdgeInsets.all(6),
                          //       decoration: BoxDecoration(
                          //         border: Border(
                          //           right: BorderSide(
                          //             color: Colors.black12,
                          //             width: 0.5,
                          //           ),
                          //         ),
                          //       ),
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           SizedBox(
                          //             height: 8,
                          //           ),
                          //           Icon(
                          //             Icons.saved_search,
                          //             color: Colors.green,
                          //             size: 40,
                          //           ),
                          //           SizedBox(
                          //             height: 3,
                          //           ),
                          //           Text(
                          //             'Evidence',
                          //           ),
                          //           SizedBox(
                          //             height: 8,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.NotesEvent);
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Icon(
                                      Icons.sticky_note_2,
                                      color: Colors.cyan,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Notes',
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
