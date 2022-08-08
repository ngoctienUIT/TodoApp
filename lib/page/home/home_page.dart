import 'package:flutter/material.dart';
import 'package:todo_app/page/home/drawer_widget.dart';
import 'package:todo_app/page/home/my_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xOffset = 0;
  double yOffset = 0;
  double scale = 1;
  bool isOpenDraw = false;

  void openDraw() => setState(() {
        xOffset = 180;
        yOffset = 50;
        scale = 0.8;
        isOpenDraw = true;
      });

  void closeDraw() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scale = 1;
        isOpenDraw = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const DrawerWidget(),
            WillPopScope(
              onWillPop: () async {
                if (isOpenDraw) {
                  closeDraw();
                  return false;
                } else {
                  return true;
                }
              },
              child: GestureDetector(
                onTap: () {
                  closeDraw();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  transform: Matrix4.translationValues(xOffset, yOffset, 0)
                    ..scale(scale),
                  child: AbsorbPointer(
                    absorbing: isOpenDraw,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isOpenDraw ? 20 : 0),
                      child: MyHome(
                        action: () {
                          openDraw();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
