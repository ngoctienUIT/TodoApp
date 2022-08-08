import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 31, 85, 1),
      body: SafeArea(
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              ClipOval(
                child: Image.network(
                  "https://i.pinimg.com/564x/29/c3/5c/29c35cc8e024cb2581dbfa797a551c8e.jpg",
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(
                width: 150,
                child: Text(
                  textAlign: TextAlign.center,
                  "Trần Ngọc Tiến",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              drawerItem(
                  icon: FontAwesomeIcons.house, title: "Home", action: () {}),
              drawerItem(
                  icon: FontAwesomeIcons.bookmark,
                  title: "Template",
                  action: () {}),
              drawerItem(
                  icon: Icons.grid_view,
                  size: 20,
                  title: "Category",
                  action: () {}),
              drawerItem(
                  icon: FontAwesomeIcons.chartPie,
                  title: "Analytic",
                  action: () {}),
              drawerItem(
                  icon: FontAwesomeIcons.gear, title: "Setting", action: () {}),
              drawerItem(
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                  title: "Log Out",
                  action: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(
      {required IconData icon,
      required String title,
      required Function action,
      double size = 16}) {
    return InkWell(
      onTap: () {
        action();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
