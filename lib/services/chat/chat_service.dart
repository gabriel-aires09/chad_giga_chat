import 'package:chad_giga_chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{
  // Puxar a instância do firestore
  final  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Puxar stream do usuário - utilizamos uma lista com map para percorrer a estrutura do arquivo json da api do firebase
  Stream<List<Map<String, dynamic>>> getUserStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // passar por cada um dos usuários
        final user = doc.data();
        // retornar os valores dos usuários
        return user;
      }).toList(); //converte para uma lista
    }); 
  }

  // Enviar mensagem
  Future<void> sendMessage(String receiverID, messsage) async {
    // puxar as informacoes do usuario atual
    final String currentUserID = _auth.currentUser!.uid;
    final String currentuserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // criar uma nova mensagem
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentuserEmail, 
      receiverID: receiverID, 
      messsage: messsage, 
      timestamp: timestamp);

    // construtor da sala de chat com id dos dois usuarios (organizado/sorted por id unico)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // garante o id da sala de batepapo seja o mesmo para duas pessoas na sala

    String chatRoomID = ids.join('_');
    
    // adicionar nova mensagem ao banco de dados
    await _firestore
      .collection("chat_rooms").
      doc(chatRoomID).
      collection("messages").
      add(newMessage.toMap());
  }

  // Pegar-puxar mensagem do db (precisa do userId e id do outro usuario)
  Stream<QuerySnapshot> getMesssages(String userID, otherUserID){
    // construct para sala de chatRoomID para dois usuarios
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
  }

}