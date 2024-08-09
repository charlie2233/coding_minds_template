import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import './api_keys.dart';
import 'package:dart_openai/dart_openai.dart';
class chat_page extends StatefulWidget {
  const chat_page({super.key});

  @override
  State<chat_page> createState() => _chat_pageState();
}
Future <void> setup() async {
  OpenAI.apiKey= CHATGPT_APIKEY;
  OpenAI.requestsTimeOut=Duration(seconds: 5);
}
class _chat_pageState extends State<chat_page> {
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

  ChatUser chatGPTuser = ChatUser(
    id: '1',
    firstName: 'AI',
    lastName: 'Counselor',
  );
  List<ChatMessage> messages = <ChatMessage>[];
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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chat),
        backgroundColor: Colors.green,
        title: Text("AI Counselor Chat"),
      ),
      body: DashChat(
        typingUsers: typingUsers,
        currentUser: user,
        onSend: (ChatMessage m) {
          getChatMessage(m);
        },
        messages: messages,
      ),
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
    setState(() {
      messages.insert(0, ChatMessage(user: chatGPTuser, createdAt: DateTime.now(),text: chatCompletion.choices.first.message.toString()));
      typingUsers.remove(chatGPTuser);
    });
  }
}
