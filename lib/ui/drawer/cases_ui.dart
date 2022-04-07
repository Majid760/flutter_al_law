import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/add_case_model.dart';
import 'package:flutter_al_law/ui/add_case_ui.dart';
import 'package:flutter_al_law/ui/components/animated_search_field.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/detailed_case_ui.dart';
import 'package:get/get.dart';

class CasesUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CasesUIController>(
      init: CasesUIController(),
      builder: (controller) => Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 6,
                  bottom: 6,
                  right: 12,
                  left: 12,
                ),
                child: AnimSearchBar(
                  width: Get.width,
                  rtl: true,
                  toggleState: (int toggle) {
                    print(toggle);
                    controller.searchBarVisibilityChanged(toggle);
                  },
                  autoFocus: true,
                  closeSearchOnSuffixTap: true,
                  textController: controller.searchFieldController,
                  onSuffixTap: () {
                    controller.clearSearch();
                  },
                ),
              ),
              Expanded(
                child: !controller.isSearching
                    ? StreamBuilder<DocumentSnapshot>(
                        stream: controller.casesStream,
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError && !snapshot.hasData) {
                            return Center(
                              child: Text('Unable to load cases'),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          List<dynamic> casesData = [];
                          print(snapshot.data.data());
                          try {
                            casesData = snapshot.data.get('cases');
                          } catch (e) {
                            print(e);
                          }
                          List<CaseModel> casesList =
                              casesData.map((element) => CaseModel.fromJson(element)).toList();

                          if (casesList == null || casesList.isEmpty) {
                            return Center(
                              child: Text('No Cases for now!'),
                            );
                          }
                          casesList.sort((a, b) =>
                              a.caseName.toLowerCase().compareTo(b.caseName.toLowerCase()));

                          return MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: LiveList.options(
                              options: options,
                              scrollDirection: Axis.vertical,
                              itemCount: casesList.length,
                              itemBuilder: animationItemBuilder(
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: SingleCaseCard(
                                    singleCase: casesList[index],
                                    onTap: () {
                                      Get.to(() => DetailedCaseUI(), arguments: [
                                        index,
                                        casesList[index].caseID,
                                        casesList[index],
                                      ]);
                                    },
                                  ),
                                ),
                                // padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          );
                        },
                      )
                    : MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: LiveList.options(
                          options: options,
                          scrollDirection: Axis.vertical,
                          itemCount: controller.searchedCustomers.length,
                          itemBuilder: animationItemBuilder(
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: SingleCaseCard(
                                singleCase: controller.searchedCustomers[index],
                                searching: true,
                                searchFieldText: controller.searchFieldController.text,
                                onTap: () {
                                  Get.to(() => DetailedCaseUI(), arguments: [
                                    index,
                                    controller.searchedCustomers[index].caseID,
                                    controller.searchedCustomers[index],
                                  ]);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: RoundIconButton(
                color: Colors.red,
                icon: Icons.add,
                onPressed: () {
                  Get.to(() => AddCaseUI());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final options = LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 100),

    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 100),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: true,
  );

  Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) animationItemBuilder(
    Widget Function(int index) child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child(index),
              ),
            ),
          );

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}
