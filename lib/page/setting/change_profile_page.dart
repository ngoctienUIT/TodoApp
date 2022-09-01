import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo_firebase.dart';
import 'package:todo_app/model/user.dart' as myuser;
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/home/widget/custom_button.dart';
import 'package:todo_app/values/app_styles.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({Key? key}) : super(key: key);

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  late final TextEditingController _nameController = TextEditingController();
  File? image;
  late myuser.User user;
  late bool check;

  @override
  void initState() {
    super.initState();
    check = true;
    _nameController.addListener(() {
      user.name = _nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return check
        ? FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("user")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (check) {
                  user = myuser.User.fromSnapshot(snapshot.requireData);
                  check = false;
                }
                _nameController.text = user.name;
                return body(context);
              }

              return const Center(child: CircularProgressIndicator());
            })
        : body(context);
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("setting".tr),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(90),
                onTap: () async {
                  await pickImage();
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: image == null
                          ? Image.network(
                              user.avatar,
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            )
                          : Image.file(image!),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 10,
                      child: Icon(Icons.image_search_rounded),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: AppStyles.h5,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  DateTime? time = await pickDate(context,
                      initDate: user.birthday,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now());
                  setState(() {
                    user.birthday = time!;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1),
                  ),
                  child: Text(
                    DateFormat("dd/MM/yyyy").format(user.birthday),
                    style: AppStyles.h5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              customButton(
                color: Colors.red,
                action: () {
                  TodoFirebase.updateUser(user);
                  Navigator.pop(context);
                },
                text: "Lưu",
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final cropImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square]);
      if (cropImage == null) return;
      setState(() {
        this.image = File(cropImage.path);
        user.avatar = this.image!.path;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
