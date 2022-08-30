import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/model/todo_firebase.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key, required this.action}) : super(key: key);
  final Function(int) action;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
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
              ClipOval(
                child: FirebaseAuth.instance.currentUser != null
                    ? Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL.toString(),
                        height: 100,
                        width: 100,
                      )
                    : Image.asset(
                        "assets/images/user.png",
                        height: 100,
                        width: 100,
                      ),
              ),
              const SizedBox(height: 10),
              FirebaseAuth.instance.currentUser != null
                  ? SizedBox(
                      width: 150,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.displayName
                            .toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () async {
                        await signInGoogle();
                        initUser();
                        showMyDialog();
                        setState(() {});
                      },
                      icon: const Icon(FontAwesomeIcons.google),
                      label: Text("signInWithGoogle".tr)),
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

  Future signInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future initUser() async {
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

  void showMyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: const Text('Bạn có muốn giữ lại task không?'),
        actions: [
          TextButton(
            onPressed: () {
              syncTodo();
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

  Future syncTodo() async {
    List<Todo> todoList = await TodoDatabase().getData();
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
          print(todo.images);
          TodoFirebase.addTodo(todo);
        }
      }
    });
  }

  Widget drawerItem(
      {required IconData icon,
      required String title,
      required Function action,
      double size = 20}) {
    return InkWell(
      onTap: () {
        action();
      },
      splashColor: Colors.transparent,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(
              icon,
              size: size,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
