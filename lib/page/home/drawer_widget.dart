import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();

                        final GoogleSignInAuthentication? googleAuth =
                            await googleUser?.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth?.accessToken,
                          idToken: googleAuth?.idToken,
                        );

                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        setState(() {});
                      },
                      icon: const Icon(FontAwesomeIcons.google),
                      label: const Text("Sign in Google")),
              const SizedBox(height: 20),
              drawerItem(
                  icon: FontAwesomeIcons.house,
                  title: "Home",
                  action: () {
                    widget.action(0);
                  }),
              drawerItem(
                  icon: FontAwesomeIcons.bookmark,
                  title: "Template",
                  action: () {
                    widget.action(1);
                  }),
              drawerItem(
                  icon: Icons.grid_view,
                  size: 25,
                  title: "Category",
                  action: () {
                    widget.action(2);
                  }),
              drawerItem(
                  icon: FontAwesomeIcons.chartPie,
                  title: "Analytic",
                  action: () {
                    widget.action(3);
                  }),
              drawerItem(
                  icon: FontAwesomeIcons.gear,
                  title: "Setting",
                  action: () {
                    widget.action(4);
                  }),
              if (FirebaseAuth.instance.currentUser != null)
                drawerItem(
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                    title: "Log Out",
                    action: () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      setState(() {});
                    }),
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
      double size = 20}) {
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
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
