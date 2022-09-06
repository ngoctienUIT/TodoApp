import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/user.dart' as myuser;

class TodoFirebase {
  static Future<String> uploadFile(String link,
      {String? folder, String? id}) async {
    Reference upload;
    if (folder != null) {
      upload =
          FirebaseStorage.instance.ref().child("$folder/$id/${basename(link)}");
    } else {
      upload = FirebaseStorage.instance
          .ref()
          .child("avatar/${FirebaseAuth.instance.currentUser!.email}");
    }

    await upload.putFile(File(link));
    return await upload.getDownloadURL();
  }

  static Future deleteFolder(String folder, String id) async {
    FirebaseStorage.instance.ref().child("$folder/$id/").delete();
  }

  static Future addTodo(Todo todo) async {
    var firestore = FirebaseFirestore.instance.collection("todo").doc(todo.id);
    List<String> imageList = [];
    for (var image in todo.images) {
      imageList.add(await uploadFile(image, folder: "images", id: todo.id));
    }
    todo.images = imageList;
    List<String> fileList = [];
    for (var file in todo.files) {
      fileList.add(await uploadFile(file, folder: "files", id: todo.id));
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
      List<String> list = (data["todo"] as List<dynamic>)
          .map((element) => element.toString())
          .toList();
      list.remove(id);
      FirebaseFirestore.instance
          .collection("data")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({"todo": list});
    });
    await FirebaseFirestore.instance.collection("todo").doc(id).delete();
  }

  static Future updateTodo(Todo todo) async {
    var firestore = FirebaseFirestore.instance.collection("todo").doc(todo.id);
    await deleteFolder("images", todo.id);
    await deleteFolder("files", todo.id);

    List<String> imageList = [];
    for (var image in todo.images) {
      imageList.add(await uploadFile(image, folder: "images", id: todo.id));
    }
    todo.images = imageList;

    List<String> fileList = [];
    for (var file in todo.files) {
      fileList.add(await uploadFile(file, folder: "files", id: todo.id));
    }
    await firestore.update(todo.toMap());
  }

  static Future initUser() async {
    var firestore = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email);
    firestore.get().then((value) {
      if (!value.exists) {
        firestore.set({
          "avatar": FirebaseAuth.instance.currentUser!.photoURL,
          "name": FirebaseAuth.instance.currentUser!.displayName,
          "birthday": DateTime.now()
        });
      }
    });
  }

  static Future updateUser(myuser.User user) async {
    var firestore = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email);
    if (await File(user.avatar).exists()) {
      user.avatar = await uploadFile(user.avatar);
    }
    firestore.update(user.toMap());
  }
}
