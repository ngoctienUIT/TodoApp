import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    var firestore = FirebaseFirestore.instance.collection("todo").doc(todo.id);
    List<String> imageList = [];
    for (var image in todo.images) {
      imageList.add(await uploadImage(image, "images", todo.id));
    }
    todo.images = imageList;
    List<String> fileList = [];
    for (var file in todo.files) {
      fileList.add(await uploadImage(file, "files", todo.id));
    }
    todo.files = fileList;
    FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((value) {
      var data = value.data() as Map<String, dynamic>;
      List<String> list = data["todo"] as List<String>;
      list.add(todo.id);
      FirebaseFirestore.instance
          .collection("data")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({"todo": list});
    });
    await firestore.set(todo.toMapSQL());
  }

  static Future deleteTodo(String id) async {
    await FirebaseFirestore.instance.collection("todo").doc(id).delete();
  }
}
