import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  final TextEditingController _userMessage = TextEditingController();

  static const apiKey = "AIzaSyA1RsZKtzCAfjq_opQQ8KJNuSRBrzkYhQM";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      controller: _userMessage,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurpleAccent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Ask Gemini...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    padding: const EdgeInsets.all(15),
                    iconSize: 30,
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.deepPurpleAccent),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: isUser ? Colors.deepPurpleAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              topRight: const Radius.circular(30),
              bottomLeft: isUser ? const Radius.circular(30) : Radius.zero,
              bottomRight: isUser ? Radius.zero : const Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              // Only show the avatar for AI messages
              if (!isUser)
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/bot.png'),
                  ),
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      date,
                      style: TextStyle(
                          color: isUser ? Colors.white70 : Colors.black54,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}
