import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_app/model/todo.dart';

class TodoFirebase {
  static Future<String> uploadImage(
      String link, String folder, String uuid) async {
    final upload = FirebaseStorage.instance.ref().child("$folder/$uuid");

    await upload.putFile(File(link));
    return await upload.getDownloadURL();
  }

  static Future addTodo(Todo todo) async {
    var firestore =
        FirebaseFirestore.instance.collection("collectionPath").doc();
    List<String> imageList = [];
    for (var image in todo.images) {
      imageList.add(await uploadImage(image, "folder", "uuid"));
    }
    todo.images = imageList;
    List<String> fileList = [];
    for (var file in todo.files) {
      fileList.add(await uploadImage(file, "folder", "uuid"));
    }
    todo.files = fileList;
    await firestore.set(todo.toMapSQL());
  }

  static Future deleteTodo(String id) async {
    await FirebaseFirestore.instance
        .collection("collectionPath")
        .doc(id)
        .delete();
  }
}
