import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';

Widget addFileWidget(
    {required Function(List<String>) getImage,
    required Function(List<String>) getFile,
    required bool isListening}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      AvatarGlow(
        animate: isListening,
        duration: const Duration(seconds: 1),
        repeat: true,
        glowColor: const Color.fromRGBO(182, 190, 224, 1),
        endRadius: 30,
        child: IconButton(
          onPressed: () {
            // startListening();
          },
          icon: const Icon(
            FontAwesomeIcons.microphone,
            color: Color.fromRGBO(182, 190, 224, 1),
          ),
        ),
      ),
      const SizedBox(width: 20),
      IconButton(
        onPressed: () async {
          var list = await pickImage();
          getImage(list);
        },
        icon: const Icon(
          FontAwesomeIcons.image,
          color: Color.fromRGBO(182, 190, 224, 1),
        ),
      ),
      const SizedBox(width: 20),
      IconButton(
        onPressed: () async {
          var list = await pickFile();
          getFile(list);
        },
        icon: const Icon(
          FontAwesomeIcons.folderOpen,
          color: Color.fromRGBO(182, 190, 224, 1),
        ),
      ),
      const SizedBox(width: 20),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          FontAwesomeIcons.palette,
          color: Color.fromRGBO(182, 190, 224, 1),
        ),
      )
    ],
  );
}
