import 'package:chad_giga_chat/components/my_textfield.dart';
import 'package:chad_giga_chat/services/auth/auth_service.dart';
import 'package:chad_giga_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail; 
  final String receiverID;
  
  ChatPage({
    super.key, 
    required this.receiverEmail,
    required this.receiverID
  });

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // servicos de chat e autenticacao
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // metodo para enviar uma mensagem
  void sendMessage() async {
    // caso tenha algo no textfield
    if (_messageController.text.isNotEmpty){
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // limpar o controlador de texto apos a mensagem enviada
      _messageController.clear();

    }
     
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          // mostre todas as mensagens
          Expanded(
            child: _buildMessageList(),
          ),
        
        // entrada do usuario
          _buildUserInput(),
        ],
      ),
    );
  }
  // Lista de mensagens
  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMesssages(receiverID, senderID), 
      builder: (context, snapshot) {
        
        // erros
        if (snapshot.hasError) {
          return const Text("Error"); 
        }

        // carregando
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text("Carregando..");
        }

        // retorna um ListView
        return ListView(
          children: 
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList()
        );
      }
    );
  }

  // Organizando as mensagens como itens
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data["message"]);
  }

  // Construindo a entrada do usuario
  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextfield(
            controller: _messageController,
            hintText: "Digite uma mensagem",
            obscureText: false,
          ),
        ),
      
        // Botão de enviar mensagens
        IconButton(
          onPressed: sendMessage, 
          icon: const Icon(
            Icons.arrow_upward
          )
        )
      ],
    );
  }
}