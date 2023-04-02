//import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Storage {
  Future<void> uploadFile(var file, String fileName, String fileOwner) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef =
          storage.ref('users').child('${fileOwner}/images/${fileName}.png');
      final uploadTask = storageRef.putBlob(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /*Future<String> getImageFromFirebaseStorage(
      String reference, String path) async {
    final ref = FirebaseStorage.instance.ref(reference).child(path);
    final data = await ref.getDownloadURL();
    final bytes = data;
    return bytes;
  }*/
  String? downloadURL;

  Future getData(String reference, String path) async {
    try {
      await downloadURLExample(reference, path);
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample(String reference, String path) async {
    downloadURL = await FirebaseStorage.instance
        .ref(reference)
        .child(path)
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}
