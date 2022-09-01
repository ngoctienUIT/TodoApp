import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class User {
  String name;
  DateTime birthday;
  String avatar;

  User({required this.name, required this.avatar, required this.birthday});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "avatar": avatar,
      "birthday": DateFormat("dd/MM/yyyy").format(birthday)
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      name: data["name"],
      avatar: data["avatar"],
      birthday: DateFormat("dd/MM/yyyy").parse(data["birthday"]),
    );
  }
}
