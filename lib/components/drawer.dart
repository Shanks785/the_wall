import 'package:flutter/material.dart';

import 'list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      backgroundColor: Colors.grey[900],
      child: const Column(children: [
      DrawerHeader(
        child: Icon(Icons.account_circle, size: 100),
      ),

      //home list
        MyListTile(icon: Icons.home, text: "H O M E"),
      //profile list

      //logout list
    ]));
  }
}
