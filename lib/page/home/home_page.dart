import 'package:flutter/material.dart';
import 'package:todo_app/page/home/drawer_widget.dart';
import 'package:todo_app/page/home/my_home.dart';
import 'package:todo_app/page/setting/setting_page.dart';

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
  int index = 0;

  void openDraw({required double x, required double y}) => setState(() {
        xOffset = x;
        yOffset = y;
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
            DrawerWidget(
              action: (index) => setState(() {
                this.index = index;
                closeDraw();
              }),
            ),
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
                        borderRadius:
                            BorderRadius.circular(isOpenDraw ? 20 : 0),
                        child: getPage()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onOpen() => openDraw(
        x: MediaQuery.of(context).size.width * 0.5,
        y: MediaQuery.of(context).size.height * 0.1,
      );

  Widget getPage() {
    switch (index) {
      case 0:
        return MyHome(action: onOpen);
      case 4:
        return SettingPage(action: onOpen);
      default:
        return MyHome(action: onOpen);
    }
  }
}
