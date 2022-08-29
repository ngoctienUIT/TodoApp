import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';

class AddFileWidget extends StatefulWidget {
  final Function(List<String>) getImage;
  final Function(List<String>) getFile;
  final Function(Color) getColor;

  const AddFileWidget(
      {Key? key,
      required this.getFile,
      required this.getImage,
      required this.getColor})
      : super(key: key);

  @override
  State<AddFileWidget> createState() => _AddFileWidgetState();
}

class _AddFileWidgetState extends State<AddFileWidget> {
  late Color color;
  late bool isListening;

  @override
  void initState() {
    super.initState();
    isListening = false;
    color = Colors.red;
  }

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                isListening = !isListening;
              });
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
            widget.getImage(list);
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
            widget.getFile(list);
          },
          icon: const Icon(
            FontAwesomeIcons.folderOpen,
            color: Color.fromRGBO(182, 190, 224, 1),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            show(context);
          },
          icon: const Icon(
            FontAwesomeIcons.palette,
            color: Color.fromRGBO(182, 190, 224, 1),
          ),
        )
      ],
    );
  }

  void show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick Color"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildColorPicker(),
            TextButton(
              onPressed: () {
                widget.getColor(color);
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildColorPicker() => BlockPicker(
        pickerColor: color,
        onColorChanged: (value) {
          color = value;
        },
        availableColors: const [
          Colors.amber,
          Colors.blue,
          Colors.brown,
          Colors.blueGrey,
          Colors.cyan,
          Colors.deepOrange,
          Colors.deepPurple,
          Colors.green,
          Colors.grey,
          Colors.orange,
          Colors.pink,
          Colors.purple,
          Colors.teal,
          Colors.red,
          Colors.yellow,
          Colors.lightGreen
        ],
      );
}
