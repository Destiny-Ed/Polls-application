import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FetchPollsProvider extends ChangeNotifier {
  List<DocumentSnapshot> _pollsList = [];
  List<DocumentSnapshot> _usersPollsList = [];

  DocumentSnapshot? _individualPoll;

  bool _isLoading = true;

  ///
  bool get isLoading => _isLoading;

  List<DocumentSnapshot> get pollsList => _pollsList;
  List<DocumentSnapshot> get userPollsList => _usersPollsList;

  DocumentSnapshot get individualPolls => _individualPoll!;

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference pollCollection =
      FirebaseFirestore.instance.collection("polls");

  ///Fetch all polls
  void fetchAllPolls() async {
    pollCollection.get().then((value) {
      if (value.docs.isEmpty) {
        _pollsList = [];
        _isLoading = false;
        notifyListeners();
      } else {
        final data = value.docs;

        _pollsList = data;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  ///Fetch user polls
  void fetchUserPolls() async {
    pollCollection.where("authorId", isEqualTo: user!.uid).get().then((value) {
      print(user!.uid);
      // print(value.docs[0].data());
      if (value.docs.isEmpty) {
        _usersPollsList.clear();
        _isLoading = false;
        notifyListeners();
      } else {
        final data = value.docs;

        _usersPollsList = data;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  ///fetch individual polls
  void fetchIndividualPolls(String id) async {
    pollCollection.doc(id).get().then((value) {
      if (!value.exists) {
        _individualPoll = value;
        _isLoading = false;
        notifyListeners();
      } else {
        final data = value;

        _individualPoll = data;
        _isLoading = false;
        notifyListeners();
      }
    });
  }
}
