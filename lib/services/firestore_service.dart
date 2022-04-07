import 'dart:typed_data';
import 'package:flutter_al_law/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final String uid;
  FireStoreService({this.uid});

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // CollectionReference cases = FirebaseFirestore.instance.collection('users');

  //Stream FireStore User
  Stream<UserModel> streamFireStoreUser() {
    print('streamFirestoreUser');
    return _db.doc('/users/$uid').snapshots().map((snapshot) => UserModel.fromMap(snapshot.data()));
  }

  //Stream FireStore User
  Future<UserModel> getFireStoreUser() {
    print('streamFirestoreUser');
    // return _db.doc('/users/$uid').snapshots().map((snapshot) => UserModel.fromMap(snapshot.data()));
    return _db
        .doc('/users/$uid')
        .get()
        .then((value) => Future.value(UserModel.fromMap(value.data())));
  }

  //Stream FireStore User
  Stream<QuerySnapshot> streamFireStoreProfiles() {
    print('streamFireStoreProfiles');
    return _db.collection('/profiles').snapshots();
  }

  //Get FireStore User
  Future<List<ProfileModel>> getFireStoreProfiles() async {
    print('getFireStoreProfiles');
    List<ProfileModel> profilesData;
    QuerySnapshot snapshot = await _db.collection('profiles').get();
    profilesData = snapshot.docs.map((doc) => ProfileModel.fromJson(doc.data(), doc.id)).toList();
    profilesData.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Future.value(profilesData);
  }

  Stream<DocumentSnapshot> streamFireStoreUserCases() {
    print('streamFireStoreUserCases');
    return _db.collection('cases').doc('$uid').snapshots();
  }

  Stream<DocumentSnapshot> streamFireStoreUserClients() {
    print('streamFireStoreUserClients');
    return _db.collection('clients').doc('$uid').snapshots();
  }

  Stream<DocumentSnapshot> streamFireStoreUserCase() {
    print('getFireStoreUserCase');
    return _db.collection('cases').doc('$uid').snapshots();
  }

  Stream<DocumentSnapshot> streamFireStoreUserSchedules() {
    print('streamFireStoreUserSchedules');
    return _db.collection('schedules').doc('$uid').snapshots();
  }

  Stream<DocumentSnapshot> streamFireStoreUserNotes() {
    print('streamFireStoreUserNotes');
    return _db.collection('notes').doc('$uid').snapshots();
    // .map((snapshot) => NoteModel.fromJson(snapshot.data())).toList();
  }

  Stream<DocumentSnapshot> streamFireStoreUserEvidences() {
    print('streamFireStoreUserEvidences');
    return _db.collection('evidences').doc('$uid').snapshots();
  }

  Future<DocumentSnapshot> getFireStoreUserClient() {
    print('getFireStoreUserClient');
    return _db.collection('clients').doc('$uid').get();
  }

  Future<List<CaseModel>> getFireStoreUserCases() async {
    print('getFireStoreUserCases');
    DocumentSnapshot snapshot = await _db.collection('cases').doc('$uid').get();
    List<dynamic> data = [];
    try {
      data = snapshot.get('cases');
    } catch (e) {
      print(e);
    }
    List<CaseModel> casesList = data.map((element) => CaseModel.fromJson(element)).toList();
    casesList.sort((a, b) => a.caseName.toLowerCase().compareTo(b.caseName.toLowerCase()));
    return Future.value(casesList);
  }

  Future<List<ClientModel>> getFireStoreUserClients() async {
    print('getFireStoreUserClients');
    DocumentSnapshot snapshot = await _db.collection('clients').doc('$uid').get();
    List<dynamic> data = [];
    try {
      data = snapshot.get('clients');
    } catch (e) {
      print(e);
    }
    List<ClientModel> casesList = data.map((element) => ClientModel.fromJson(element)).toList();
    casesList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Future.value(casesList);
  }

  Future<List<ScheduleModel>> getAllFireStoreSchedules() {
    print('getFireStoreUserSchedules');
    return _db.collection('schedules').doc('$uid').get().then((value) {
      List<dynamic> schedulesData = [];
      try {
        schedulesData = value.get('schedules');
      } catch (e) {
        print(e);
      }
      List<ScheduleModel> schedulesList =
          schedulesData.map((element) => ScheduleModel.fromJson(element)).toList();
      // schedulesList.retainWhere((element) => element.id == id);
      return Future.value(schedulesList);
    });
  }

  Future<List<ScheduleModel>> getFireStoreUserSchedules(String id) {
    print('getFireStoreUserSchedules');
    return _db.collection('schedules').doc('$uid').get().then((value) {
      List<dynamic> schedulesData = [];
      try {
        schedulesData = value.get('schedules');
      } catch (e) {
        print(e);
      }
      List<ScheduleModel> schedulesList =
          schedulesData.map((element) => ScheduleModel.fromJson(element)).toList();
      schedulesList.retainWhere((element) => element.id == id);
      return Future.value(schedulesList);
    });
  }

  Future<List<NoteModel>> getFireStoreUserNotes(String id) {
    print('getFireStoreUserNotes');
    return _db.collection('notes').doc('$uid').get().then((value) {
      List<dynamic> notesData = [];
      try {
        notesData = value.get('notes');
      } catch (e) {
        print(e);
      }
      List<NoteModel> notesList = notesData.map((element) => NoteModel.fromJson(element)).toList();
      notesList.retainWhere((element) => element.id == id);
      return Future.value(notesList);
    });
  }

  //updates the fireStore user name in users collection
  void updateUser(
    String userName,
    String mobile,
    String experience,
    List<String> selectedServices,
    List<String> selectedDegrees,
  ) {
    _db.doc('/users/$uid').update({
      'name': userName,
      'mobile': mobile,
      'experience': experience,
      'services': selectedServices,
      'degrees': selectedDegrees,
    });
    _db.doc('/profiles/$uid').update({
      'name': userName,
      'mobile': mobile,
      'experience': experience,
      'services': selectedServices,
      'degrees': selectedDegrees,
    });
  }

  //updates the fireStore user name in users collection
  void updateUserProfile(Uint8List image) {
    _db.doc('/users/$uid').update({'photoBlob': Blob(image)});
    _db.doc('/profiles/$uid').update({'photoBlob': Blob(image)});
  }

  //updates the fireStore user name in users collection
  void addLawyerProfileRating(List<int> ratingsList, List<String> reviewsList) {
    _db.collection('profiles').doc('$uid').set({
      'ratings': ratingsList,
      'reviews': reviewsList,
    }, SetOptions(merge: true));
  }

  //add schedule
  void addSchedule(ScheduleModel data) {
    _db.collection('schedules').doc('$uid').set({
      "schedules": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  //add note
  void addNote(NoteModel data) {
    _db.collection('notes').doc('$uid').set({
      "notes": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  //add case against user
  void addCase(CaseModel data) {
    _db.collection('cases').doc('$uid').set({
      "cases": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  //add client
  void addClient(ClientModel data) {
    _db.collection('clients').doc('$uid').set({
      "clients": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  Future<void> updateClient(ClientModel data, ClientModel oldData) async {
    await _db.collection('clients').doc('$uid').update({
      "clients": FieldValue.arrayRemove([oldData.toJson()])
    });
    await _db.collection('clients').doc('$uid').set({
      "clients": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  Future<void> deleteClient(ClientModel data) async {
    await _db.collection('clients').doc('$uid').update({
      "clients": FieldValue.arrayRemove([data.toJson()])
    });
  }

  Future<void> updateCase(CaseModel data, CaseModel oldData) async {
    await _db.collection('cases').doc('$uid').update({
      "cases": FieldValue.arrayRemove([oldData.toJson()])
    });
    await _db.collection('cases').doc('$uid').set({
      "cases": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  Future<void> deleteCase(CaseModel data) async {
    await _db.collection('cases').doc('$uid').update({
      "cases": FieldValue.arrayRemove([data.toJson()])
    });
  }

  Future<void> updateNote(NoteModel data, NoteModel oldData) async {
    await _db.collection('notes').doc('$uid').update({
      "notes": FieldValue.arrayRemove([oldData.toJson()])
    });
    await _db.collection('notes').doc('$uid').set({
      "notes": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  Future<void> deleteNotes(List<NoteModel> data) async {
    List<dynamic> elements = [];
    data.forEach((note) {
      elements.add(note.toJson());
    });
    await _db.collection('notes').doc('$uid').update({
      "notes": FieldValue.arrayRemove(elements),
    });
  }

  Future<void> updateSchedule(ScheduleModel data, ScheduleModel oldData) async {
    await _db.collection('schedules').doc('$uid').update({
      "schedules": FieldValue.arrayRemove([oldData.toJson()])
    });
    await _db.collection('schedules').doc('$uid').set({
      "schedules": FieldValue.arrayUnion([data.toJson()])
    }, SetOptions(merge: true));
  }

  Future<void> deleteSchedules(List<ScheduleModel> data) async {
    List<dynamic> elements = [];
    data.forEach((schedule) {
      elements.add(schedule.toJson());
    });
    await _db
        .collection('schedules')
        .doc('$uid')
        .update({"schedules": FieldValue.arrayRemove(elements)});
  }
}

// addImageToFirebase(file) async {
//   firebase_storage.UploadTask uploadTask;
//   AuthController authController = AuthController.to;
//
//   //CreateReference to path.
//   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//       .ref()
//       .child('profile_images')
//       .child('/${authController.firestoreUser.value.uid}.jpg');
//
//   final metadata = firebase_storage.SettableMetadata(
//       contentType: 'image/jpeg', customMetadata: {'picked-file-path': file.path});
//
//   uploadTask = ref.putFile(io.File(file.path), metadata);
//
//   try {
//     // Storage tasks function as a Delegating Future so we can await them.
//     firebase_storage.TaskSnapshot snapshot = await uploadTask;
//     print('Uploaded ${snapshot.bytesTransferred} bytes.');
//     final link = await ref.getDownloadURL();
//
//     //Here you can get the download URL when the task has been completed.
//     print("Download URL " + link.toString());
//     Get.snackbar(
//       'Success',
//       'File Uploaded Successfully',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 3),
//       backgroundColor: Get.theme.snackBarTheme.backgroundColor,
//       colorText: Get.theme.snackBarTheme.actionTextColor,
//     );
//     return link;
//   } on firebase_core.FirebaseException catch (e) {
//     // The final snapshot is also available on the task via `.snapshot`,
//     // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
//     print(uploadTask.snapshot);
//
//     if (e.code == 'permission-denied') {
//       print('User does not have permission to upload to this reference.');
//     }
//     Get.snackbar(
//       'No File',
//       'No file was selected',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 3),
//       backgroundColor: Get.theme.snackBarTheme.backgroundColor,
//       colorText: Get.theme.snackBarTheme.actionTextColor,
//     );
//   }
// }
