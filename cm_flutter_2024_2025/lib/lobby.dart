import 'dart:async';
import 'dart:convert';

import 'package:cm_flutter_2024_2025/models/address.dart';
import 'package:cm_flutter_2024_2025/models/client_details.dart';
import 'package:cm_flutter_2024_2025/models/delivery.dart';
import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:cm_flutter_2024_2025/queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  LobbyState createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  bool isReady = false;
  Map<String, dynamic>? messageDetails;

  Timer? _messageCheckTimer;

  void _onReadyPressed(DeliveryRouteBloc deliveryRouteBloc) {
    _messageCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      final message = await poolDeliveryMessage();
      if (message != null) {
        _messageCheckTimer?.cancel(); // Stop the timer for checking messages
        debugPrint('poolDeliveryMessageSuccess');
        setState(() {
          if (message.body != null) {
            messageDetails = jsonDecode(message.body!);
          }
          messageDetails?['messageReceiptHandle'] = message.receiptHandle;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    });
    //handle ready stuff
    // isReady = true;
    if (isReady) {
      Delivery delivery1 = Delivery(
        1,
        ClientDetails(
          101,
          "João Silva",
          "+351 912 345 678"
        ),
        Address(
          201,
          "Rua das Flores, 123",
          "Lisboa",
          "Lisboa",
          1000,
          "Portugal",
          38.7223, 
          -9.1393
        ),
        Address(
          202,
          "Avenida da Liberdade, 456",
          "Lisboa",
          "Lisboa",
          1250,
          "Portugal",
          38.7184,
          -9.1418
        ),
        "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92",
        DateTime.now()
      );        

      Delivery delivery2 = Delivery(
        2,
        ClientDetails(
          102,
          "Maria Santos",
          "+351 923 456 789"
        ),
        Address(
          203,
          "Rua do Comércio, 78",
          "Porto",
          "Porto",
          4050,
          "Portugal",
          41.1494,
          -8.6107
        ),
        Address(
          204,
          "Praça da Ribeira, 90",
          "Porto",
          "Porto",
          4050,
          "Portugal",
          41.1409,
          -8.6132
        ),
        "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92",
        DateTime.now()
      );

      DeliveryRoute deliveryRoute=DeliveryRoute(1,[delivery1,delivery2]);
      deliveryRouteBloc.add(DeliveryRouteReceivedEvent(deliveryRoute));
      Navigator.pushNamed(context, '/deliveryMap');
    } else {
      // Handle the condition when not ready
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waiting for delivery...'),
          duration: Duration(minutes: 1),
        ),
      );
    }
  }

  void _onAcceptDeliveryPressed() {
    // Handle the accept delivery action
    debugPrint('Delivery accepted');
    if (messageDetails == null || messageDetails!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery details are empty.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      deleteMessageFromQueue(messageDetails?['messageReceiptHandle']);
      Navigator.pushNamed(context, '/deliveryMap');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Lobby'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: messageDetails == null
                      ? _buildEmptyState()
                      : _buildDeliveryCard(),
                ),
              ),
              const SizedBox(height: 20),
              _buildReadyButton(BlocProvider.of<DeliveryRouteBloc>(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.delivery_dining, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'No deliveries available',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap "Ready to Deliver" to start',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildDeliveryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Delivery!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, 'Name', messageDetails!['name']),
            _buildInfoRow(
                Icons.info_outline, 'Details', messageDetails!['details']),
            _buildInfoRow(Icons.access_time, 'Time', messageDetails!['time']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onAcceptDeliveryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Accept Delivery',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildReadyButton(DeliveryRouteBloc deliveryRouteBloc) {
    return ElevatedButton(
      onPressed: (){_onReadyPressed(deliveryRouteBloc);},
      style: ElevatedButton.styleFrom(
        backgroundColor: isReady ? Colors.orange : Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isReady ? 'Stop Deliveries' : 'Ready to Deliver',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
