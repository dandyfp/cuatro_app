import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class MapsPage extends StatefulWidget {
  final String idUser;
  final UserData user;

  const MapsPage({
    required this.idUser,
    required this.user,
    super.key,
  });

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenStreetMapSearchAndPick(
        buttonColor: Colors.blue,
        buttonText: 'Set Location',
        onPicked: (pickedData) {
          setState(() {});
        },
      ),
    );
  }
}
