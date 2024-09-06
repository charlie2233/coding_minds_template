import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import './api_keys.dart';
import 'package:dart_openai/dart_openai.dart';
class chat_page extends StatefulWidget {
  const chat_page({super.key});

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  Future <String> setup() async {
    OpenAI.apiKey= CHATGPT_APIKEY;
    OpenAI.requestsTimeOut=Duration(seconds: 5);
    if(!await checkIfUserMessagesExisits()) {
      await createUserMessage();
      await createAIMessage();
    }
    messages = await readUserMessage();
    messages.addAll(await readAIMessage());
    messages.sort((b,a) => a.createdAt.compareTo(b.createdAt));
    return "done";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }
  ChatUser user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
 final FirebaseAuth auth = FirebaseAuth.instance;
  ChatUser chatGPTuser = ChatUser(
    id: '2',
    firstName: 'AI',
    lastName: 'Counselor',
  );
  late List<ChatMessage> messages;
  // the system message that will be sent to the request.
  final systemMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "return any message you are given as JSON.",
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  );
  List<ChatUser> typingUsers = <ChatUser>[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setup(),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.chat),
              backgroundColor: Colors.green,
              title: Text("AI Counselor Chat"),
            ),
            body: DashChat(
              typingUsers: typingUsers,
              currentUser: user,
              onSend: (ChatMessage m) async {
                await sendMessage(m);
              },
              messages: messages,
            ),
          );
        }
        else{
          return Center(child: CircularProgressIndicator());
        }

      }
    );
  }
  Future<void> getChatMessage(ChatMessage m) async {
    setState(() {
      messages.insert(0, m);
      typingUsers.add(chatGPTuser);
    });
    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          m.text,
        ),

        //! image url contents are allowed only for models with image support such gpt-4.

      ],
      role: OpenAIChatMessageRole.user,
    );

// all messages to be sent.
    final requestMessages = [
      systemMessage,
      userMessage,
    ];

// the actual request.
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      responseFormat: {"type": "json_object"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 200,
    );
    await addAIMessage(chatCompletion.choices.first.message.toString());
    setState(() {
      messages.insert(0, ChatMessage(user: chatGPTuser, createdAt: DateTime.now(),text: chatCompletion.choices.first.message.toString()));
      typingUsers.remove(chatGPTuser);
    });
  }
Future<bool> checkIfUserMessagesExisits() async{
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users_ai_chat');
      var doc = await collectionRef.doc(auth.currentUser?.uid).get();
      return doc.exists;
    }catch (e){
      throw e;
    }
}

  Future<void> createUserMessage() async {
    final userDocument = FirebaseFirestore.instance.collection('users_ai_chat').doc(auth.currentUser?.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async{
      await transaction.set(userDocument, {'user':{}}, SetOptions(merge: true));
    }).then(
        (value) => print("Success"),
      onError: (e) =>print("error: $e")
    );
  }
  Future<void> createAIMessage() async {
    final userDocument = FirebaseFirestore.instance.collection('users_ai_chat').doc(auth.currentUser?.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async{
      await transaction.set(userDocument, {'AI':{}}, SetOptions(merge: true));
    }).then(
            (value) => print("Success"),
        onError: (e) =>print("error: $e")
    );
  }
  Future<void> sendMessage(ChatMessage m) async{
    if(await checkIfUserMessagesExisits()==false){
      await createUserMessage();
    }
    await addUserMessage(m.text);
    await getChatMessage(m);
  }
Future<List<ChatMessage>> readUserMessage() async {
    List<ChatMessage> allOurMessages = [];
    if(await checkIfUserMessagesExisits()==false){
      return allOurMessages;
    }
  final userMessages = FirebaseFirestore.instance.collection('users_ai_chat').doc(auth.currentUser?.uid);
  Map<String, dynamic> messagesFromUser = {};

  await userMessages.get().then(
  (DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  messagesFromUser = data["user"];
  },
  onError: (e) => print("Error getting document: $e"),
  );
  messagesFromUser.forEach((k,v){
      ChatMessage temp = ChatMessage(user : user, createdAt: DateTime.parse(k),text: v);
      allOurMessages.add(temp);
    });
  return allOurMessages;
}


  Future<List<ChatMessage>> readAIMessage() async {
    List<ChatMessage> allOurMessages = [];
    if(await checkIfUserMessagesExisits()==false){
      return allOurMessages;
    }
    final userMessages = FirebaseFirestore.instance.collection('users_ai_chat').doc(auth.currentUser?.uid);
    Map<String, dynamic> messagesFromUser = {};

    await userMessages.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        messagesFromUser = data["AI"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    messagesFromUser.forEach((k,v){
      ChatMessage temp = ChatMessage(user : chatGPTuser, createdAt: DateTime.parse(k),text: v);
      allOurMessages.add(temp);
    });
    return allOurMessages;
  }


  Future<void> addUserMessage(String message) async {
    final userMessages = FirebaseFirestore.instance.collection('users_ai_chat').doc(auth.currentUser?.uid);
    Map<String, dynamic> messagesFromUser = {};
    
    await userMessages.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        messagesFromUser = data["user"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    messagesFromUser[DateTime.now().toString()]=message;
    return userMessages.update({"user":messagesFromUser});
  }
  Future<void> addAIMessage(String message) async {
    final userMessages = FirebaseFirestore.instance.collection('users_ai_chat').doc(auth.currentUser?.uid);
    Map<String, dynamic> messagesFromUser = {};

    await userMessages.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        messagesFromUser = data["AI"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    messagesFromUser[DateTime.now().toString()]=message;
    return userMessages.update({"AI":messagesFromUser});
  }
}
