import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_app/model/todo.dart';
import 'package:uuid/uuid.dart';

class TodoFirebase {
  static Future<String> uploadFile(
      String link, String folder, String id) async {
    final upload = FirebaseStorage.instance
        .ref()
        .child("$folder/$id/${const Uuid().v1()}");

    await upload.putFile(File(link));
    return await upload.getDownloadURL();
  }

  static Future addTodo(Todo todo) async {
    var firestore = FirebaseFirestore.instance.collection("todo").doc(todo.id);
    List<String> imageList = [];
    for (var image in todo.images) {
      imageList.add(await uploadFile(image, "images", todo.id));
    }
    todo.images = imageList;
    List<String> fileList = [];
    for (var file in todo.files) {
      fileList.add(await uploadFile(file, "files", todo.id));
    }
    todo.files = fileList;
    var firestoreData = FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.email.toString());
    firestoreData.get().then((value) {
      if (value.exists) {
        var data = value.data() as Map<String, dynamic>;
        List<String> list =
            (data["todo"] as List<dynamic>).map((id) => id.toString()).toList();
        list.add(todo.id);
        firestoreData.update({"todo": list});
      } else {
        List<String> list = [todo.id];
        firestoreData.set({"todo": list});
      }
    });
    await firestore.set(todo.toMap());
  }

  static Future deleteTodo(String id) async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      var data = value.data() as Map<String, dynamic>;
      List<String> list = data["todo"] as List<String>;
      list.remove(id);
      FirebaseFirestore.instance
          .collection("data")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({"todo": list});
    });
    await FirebaseFirestore.instance.collection("todo").doc(id).delete();
  }
}
