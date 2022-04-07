import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/detailed_note_ui.dart';
import 'package:get/get.dart';

class NotesUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesUIController>(
      init: NotesUIController(),
      builder: (controller) => Column(
        children: [
          Material(
            color: Colors.black,
            elevation: 2,
            child: TabBar(
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              // isScrollable: true,
              tabs: <Tab>[
                new Tab(
                  text: "Client Notes",
                ),
                new Tab(
                  text: "Cases Notes",
                ),
              ],
              controller: controller.tabController,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Expanded(
            child: TabBarView(
              children: [
                ClientNotesWidget(),
                CaseNotesWidget(),
              ],
              controller: controller.tabController,
            ),
          ),
        ],
      ),
    );
  }
}

class CaseNotesWidget extends StatefulWidget {
  const CaseNotesWidget({Key key}) : super(key: key);

  @override
  _CaseNotesWidgetState createState() => _CaseNotesWidgetState();
}

class _CaseNotesWidgetState extends State<CaseNotesWidget>
    with AutomaticKeepAliveClientMixin<CaseNotesWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<CasesNotesController>(
      init: CasesNotesController(),
      builder: (controller) {
        return StreamBuilder<DocumentSnapshot>(
          stream: controller.notesStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError && !snapshot.hasData) {
              return Center(
                child: Text('Unable to load notes'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            List<dynamic> notesData = [];
            print(snapshot.data.data());
            try {
              notesData = snapshot.data.get('notes');
            } catch (e) {
              print(e);
            }
            List<NoteModel> notesList =
                notesData.map((element) => NoteModel.fromJson(element)).toList();
            notesList.retainWhere((element) => element.type == "Case");

            if (notesList == null || notesList.isEmpty) {
              return Center(
                child: Text('No notes for now!'),
              );
            }

            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleNoteCard(
                    note: notesList[index],
                    onTap: () {
                      Get.to(() => DetailedNoteUI(), arguments: [notesList[index]]);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CasesNotesController extends GetxController {
  static CasesNotesController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<DocumentSnapshot> notesStream;
  @override
  void onInit() {
    super.onInit();
    notesStream = fireStoreService.streamFireStoreUserNotes();
  }
}

class ClientNotesWidget extends StatefulWidget {
  const ClientNotesWidget({Key key}) : super(key: key);

  @override
  _ClientNotesWidgetState createState() => _ClientNotesWidgetState();
}

class _ClientNotesWidgetState extends State<ClientNotesWidget>
    with AutomaticKeepAliveClientMixin<ClientNotesWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ClientNotesController>(
      init: ClientNotesController(),
      builder: (controller) {
        return StreamBuilder<DocumentSnapshot>(
          stream: controller.notesStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError && !snapshot.hasData) {
              return Center(
                child: Text('Unable to load notes'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            List<dynamic> notesData = [];
            print(snapshot.data.data());
            try {
              notesData = snapshot.data.get('notes');
            } catch (e) {
              print(e);
            }
            List<NoteModel> notesList =
                notesData.map((element) => NoteModel.fromJson(element)).toList();
            notesList.retainWhere((element) => element.type == "Client");

            if (notesList == null || notesList.isEmpty) {
              return Center(
                child: Text('No notes for now!'),
              );
            }

            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleNoteCard(
                    note: notesList[index],
                    onTap: () {
                      Get.to(() => DetailedNoteUI(), arguments: [notesList[index]]);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ClientNotesController extends GetxController {
  static ClientNotesController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<DocumentSnapshot> notesStream;
  @override
  void onInit() {
    super.onInit();
    notesStream = fireStoreService.streamFireStoreUserNotes();
  }
}
