import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/model/todo_firebase.dart';
import 'package:todo_app/model/user.dart' as myuser;
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:todo_app/page/home/widget/drawer_item.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key, required this.action}) : super(key: key);
  final Function(int) action;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> streamSub;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) listenTodo();
  }

  @override
  void dispose() {
    if (FirebaseAuth.instance.currentUser != null) streamSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 31, 85, 1),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              FirebaseAuth.instance.currentUser == null
                  ? notLogin()
                  : StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("user")
                          .doc(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          myuser.User user =
                              myuser.User.fromSnapshot(snapshot.requireData);
                          return logged(user);
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  drawerItem(
                      icon: FontAwesomeIcons.house,
                      title: "home".tr,
                      action: () {
                        widget.action(0);
                      }),
                  drawerItem(
                      icon: FontAwesomeIcons.chartPie,
                      title: "analytic".tr,
                      action: () {
                        widget.action(1);
                      }),
                  drawerItem(
                      icon: FontAwesomeIcons.rectangleAd,
                      size: 25,
                      title: "ads".tr,
                      action: () {
                        widget.action(2);
                      }),
                  drawerItem(
                      icon: FontAwesomeIcons.gear,
                      title: "setting".tr,
                      action: () {
                        widget.action(3);
                      }),
                  drawerItem(
                      icon: Icons.info_outline_rounded,
                      size: 25,
                      title: "about".tr,
                      action: () {
                        widget.action(4);
                      }),
                  if (FirebaseAuth.instance.currentUser != null)
                    drawerItem(
                        icon: FontAwesomeIcons.arrowRightFromBracket,
                        title: "logout".tr,
                        action: () async {
                          streamSub.cancel();
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();
                          setState(() {});
                        }),
                ],
              ),
              const Spacer(),
              const Text(
                "v0.1.1 Beta",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget logged(myuser.User user) {
    return Column(
      children: [
        ClipOval(
          child: Image.network(
            user.avatar,
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 150,
          child: Text(
            user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget notLogin() {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            "assets/images/user.png",
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            if (await signInGoogle()) {
              TodoFirebase.initUser();
              showMyDialog();
              setState(() {});
            }
          },
          icon: const Icon(FontAwesomeIcons.google),
          label: Text("signInWithGoogle".tr),
        ),
      ],
    );
  }

  Future<bool> signInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      listenTodo();
      widget.action(0);
      return true;
    } else {
      return false;
    }
  }

  Future showMyDialog() async {
    List<Todo> todoList = await TodoDatabase().getData();
    if (todoList.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Bạn có muốn giữ lại task không?'),
          actions: [
            TextButton(
              onPressed: () {
                syncTodo(todoList);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            )
          ],
        ),
      );
    }
  }

  Future listenTodo() async {
    streamSub = FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .snapshots()
        .listen((event) async {
      var data = event.data() as Map<String, dynamic>;
      List<String> list = (data["todo"] as List<dynamic>)
          .map((todo) => todo.toString())
          .toList();
      List<String> todoList = (await TodoDatabase().getData())
          .map((todo) => todo.toString())
          .toList();
      for (var todo in list) {
        if (!todoList.contains(todo)) {
          await FirebaseFirestore.instance
              .collection("todo")
              .doc(todo)
              .get()
              .then((value) async {
            Todo todoData = Todo.fromSnapshot(value);
            await TodoDatabase().insertTodo(todoData);
          });
        }
      }
    });
    streamSub.onDone(() {
      BlocProvider.of<TodoBloc>(context).add(UpdateEvent());
    });
  }

  Future syncTodo(List<Todo> todoList) async {
    for (int i = 0; i < todoList.length; i++) {
      List<String> images = (await TodoDatabase().getImageData(todoList[i].id))
          .map((image) => image.link)
          .toList();
      List<String> files = (await TodoDatabase().getFileData(todoList[i].id))
          .map((file) => file.link)
          .toList();
      todoList[i].images = images;
      todoList[i].files = files;
    }
    FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      if (value.exists) {
        var data = value.data() as Map<String, dynamic>;
        List<String> list = (data["todo"] as List<dynamic>)
            .map((todo) => todo.toString())
            .toList();
        for (var todo in todoList) {
          if (list.contains(todo.id)) {
            TodoFirebase.updateTodo(todo);
          } else {
            TodoFirebase.addTodo(todo);
          }
        }
      } else {
        for (var todo in todoList) {
          TodoFirebase.addTodo(todo);
        }
      }
    });
  }
}
