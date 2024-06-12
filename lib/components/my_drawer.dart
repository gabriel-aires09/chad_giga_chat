import 'package:chad_giga_chat/services/auth/auth_service.dart';
import 'package:chad_giga_chat/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //logo
          DrawerHeader(child: Center(
            child: Icon(Icons.message,
            color: Theme.of(context).colorScheme.primary,
            size: 40,),)),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // configurações
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("C O N F I G"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(),));
              },
            ),
          ),

          
          const SizedBox(height: 300,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text("S A I R"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],),
    
    );
  }
}