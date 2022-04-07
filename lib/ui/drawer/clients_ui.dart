import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/add_client_model.dart';
import 'package:flutter_al_law/ui/components/animated_search_field.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/ui.dart';
import 'package:get/get.dart';

class ClientsUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsUIController>(
      init: ClientsUIController(),
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
                        stream: controller.clientsStream,
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError && !snapshot.hasData) {
                            return Center(
                              child: Text('Unable to load clients'),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          List<dynamic> clientsData = [];
                          try {
                            clientsData = snapshot.data.get('clients');
                          } catch (e) {
                            print(e);
                          }
                          List<ClientModel> clientsList =
                              clientsData.map((element) => ClientModel.fromJson(element)).toList();

                          if (clientsList != null && clientsList.isEmpty) {
                            return Center(
                              child: Text('No Clients for now!'),
                            );
                          }

                          clientsList
                              .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

                          return MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: ListView.builder(
                                itemCount: clientsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 1,
                                    child: ListTile(
                                      // dense: true,
                                      leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.deepOrange,
                                          ),
                                          child: Center(
                                            child: AutoSizeText(
                                              clientsList[index].name.substring(0, 1),
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                                      title: Text(clientsList[index].name),
                                      trailing: Icon(
                                        Icons.arrow_right,
                                        size: 28,
                                        color: Colors.black54,
                                      ),
                                      subtitle: Text(
                                        clientsList[index].city ?? '',
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      onTap: () {
                                        Get.to(() => DetailedClientUI(), arguments: [
                                          index,
                                          clientsList[index],
                                          clientsList[index].id
                                        ]);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: ListView.builder(
                            itemCount: controller.searchedClients.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 1,
                                child: ListTile(
                                  // dense: true,
                                  leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.deepOrange,
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                          controller.searchedClients[index].name.substring(0, 1),
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  // title: Text(controller.searchedClients[index].name),
                                  title: RichText(
                                    text: TextSpan(
                                      children: highlightOccurrences(
                                        controller.searchedClients[index].name,
                                        controller.searchFieldController.text,
                                      ),
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_right,
                                    size: 28,
                                    color: Colors.black54,
                                  ),
                                  subtitle: Text(
                                    controller.searchedClients[index].city ?? '',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  onTap: () {
                                    Get.to(() => DetailedClientUI(), arguments: [
                                      index,
                                      controller.searchedClients[index],
                                      controller.searchedClients[index].id
                                    ]);
                                  },
                                ),
                              );
                            },
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
                color: Colors.deepOrange,
                icon: Icons.add,
                onPressed: () {
                  Get.to(() => AddClientUI());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

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
