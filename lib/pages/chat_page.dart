import 'package:chad_giga_chat/components/chat_bubble.dart';
import 'package:chad_giga_chat/components/my_textfield.dart';
import 'package:chad_giga_chat/services/auth/auth_service.dart';
import 'package:chad_giga_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail; 
  final String receiverID;
  
  const ChatPage({
    super.key, 
    required this.receiverEmail,
    required this.receiverID
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // servicos de chat e autenticacao
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // textfield focus
  FocusNode myFocusNode = FocusNode();
  
  @override
  void initState(){
    super.initState();
  
    // adicionar o listener ao nodulo de foco (FocusNode)
    myFocusNode.addListener(() { // Remove the name from the function expression
      if (myFocusNode.hasFocus){
        Future.delayed(
          const Duration(milliseconds: 500), // Correct the spelling of 'milliseconds'
          () => scrollDown(),
        );
      }
    });

    // esperar a listview renderizar, para entao iniciar o scroll no final da pagina
    Future.delayed(const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // controlar o scroll da tela do chat
  final ScrollController _scrollController = ScrollController();
  void scrollDown (){
   _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn); 
  }

  // metodo para enviar uma mensagem
  void sendMessage() async {
    // caso tenha algo no textfield
    if (_messageController.text.isNotEmpty){
      // send the message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      // limpar o controlador de texto apos a mensagem enviada
      _messageController.clear();

    }
    scrollDown();
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
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
      stream: _chatService.getMesssages(widget.receiverID, senderID), 
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
          controller: _scrollController,
          children: 
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList()
        );
      }
    );
  }

  // Organizando as mensagens como itens
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // e o usuario atual?
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // alinhar mensagem a direita se e o usuario atual, caso nao alinha a esquerda
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
        ],
      ));
  } 

  // Construindo a entrada do usuario
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: "Digite uma mensagem",
              obscureText: false,
              focusNode:  myFocusNode,
            ),
          ),
        
          // Botão de enviar mensagens
          Container(
            decoration: const BoxDecoration(color: Colors.green,
            shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              )
            ),
          )
        ],
      ),
    );
  }
}