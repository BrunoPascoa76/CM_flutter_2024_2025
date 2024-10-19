import 'package:flutter/material.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  LobbyState createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  bool isReady = false;

  void _onReadyPressed() {
    //handle ready stuff
    isReady = true;
    if (isReady) {
      Navigator.pushNamed(context, '/deliveryMap');
    } else {
      // Handle the condition when not ready
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not ready yet!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _onReadyPressed,
          child: const Text('Ready to deliver'),
        ),
      ),
    );
  }
}
