import 'package:chad_giga_chat/components/user_title.dart';
import 'package:chad_giga_chat/pages/chat_page.dart';
import 'package:chad_giga_chat/services/auth/auth_service.dart';
import 'package:chad_giga_chat/components/my_drawer.dart';
import 'package:chad_giga_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  
  // chat e serviço de autenticação
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  
  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // construir uma lista de usuarios, tendo como excecao o usuario que ja esta logado
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot){
        // Retorna erro, caso não consiga acessar 
        if (snapshot.hasError){
          return const Text("Error");
        }
        
        if (snapshot.connectionState  == ConnectionState.waiting){
          return const Text("Loading...");
        }

        // retorna a lista de usuarios
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      }
    );
  }
  
  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context){
    // mostrar todos os usuarios, exceto o que esta logado
    if (userData["email"] != _authService.getCurrentUser()!.email){
      return UserTile(
        text: userData["email"], 
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"],
              receiverID: userData["uid"],
            ),
          )
        );
      },
    );
  } else {
      return Container();
    }
  }
}
