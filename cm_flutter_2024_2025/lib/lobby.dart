import 'dart:async';

import 'package:cm_flutter_2024_2025/models/address.dart';
import 'package:cm_flutter_2024_2025/models/client_details.dart';
import 'package:cm_flutter_2024_2025/models/delivery.dart';
import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  LobbyState createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  bool isReady = true;
  bool isLoading = true;
  Map<String, dynamic>? messageDetails;
  Delivery? _currentDelivery;
  Timer? _messageCheckTimer;

  @override
  void initState() {
    super.initState();
    Delivery delivery1 = Delivery(
      1,
      ClientDetails(101, "João Silva", "+351 912 345 678"),
      Address(201, "Rua das Flores, 123", "Lisboa", "Lisboa", 1000, "Portugal",
          38.7223, -9.1393),
      Address(202, "Avenida da Liberdade, 456", "Lisboa", "Lisboa", 1250,
          "Portugal", 38.7184, -9.1418),
      "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92",
      DateTime.now(),
    );

    Delivery delivery2 = Delivery(
      2,
      ClientDetails(102, "Maria Santos", "+351 923 456 789"),
      Address(203, "Rua do Comércio, 78", "Porto", "Porto", 4050, "Portugal",
          41.1494, -8.6107),
      Address(204, "Praça da Ribeira, 90", "Porto", "Porto", 4050, "Portugal",
          41.1409, -8.6132),
      "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92",
      DateTime.now(),
    );

    DeliveryRoute deliveryRoute = DeliveryRoute(1, [delivery1, delivery2]);
    BlocProvider.of<DeliveryRouteBloc>(context)
        .add(DeliveryRouteReceivedEvent(deliveryRoute));

    Future.delayed(const Duration(seconds: 2), () {
      if (isReady && mounted) {
        setState(() {
          _currentDelivery = delivery1;
          isLoading = false;
        });
      }
    });
  }

  void _onReadyPressed(DeliveryRouteBloc deliveryRouteBloc) {
    setState(() {
      isReady = !isReady;
      isLoading = isReady;
    });

    if (isReady) {
    } else {
      _currentDelivery = null;
      _messageCheckTimer?.cancel();
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stopped checking for deliveries.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _onAcceptDeliveryPressed() {
    debugPrint('Delivery accepted');
    if (_currentDelivery != null) {
      // deleteMessageFromQueue(messageDetails?['messageReceiptHandle']);
      Navigator.pushNamed(context, '/deliveryMap');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery details are empty.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageCheckTimer?.cancel();
    super.dispose();
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
                  child: _buildContent(),
                ),
              ),
              const SizedBox(height: 20),
              _buildReadySwitch(BlocProvider.of<DeliveryRouteBloc>(context)),
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
          'Toggle "Ready to Deliver" to start',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Getting your delivery...', style: TextStyle(fontSize: 16)),
        ],
      );
    } else if (_currentDelivery == null) {
      return _buildEmptyState();
    } else {
      return _buildDeliveryCard();
    }
  }

  Widget _buildDeliveryInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue[700]),
              const SizedBox(width: 6),
              Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard() {
    if (_currentDelivery == null) {
      return _buildEmptyState();
    }
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
            _buildDeliveryInfoRow(Icons.person, 'Client Name',
                _currentDelivery!.clientDetails.clientName),
            _buildDeliveryInfoRow(Icons.phone, 'Client Phone',
                _currentDelivery!.clientDetails.phoneNumber),
            _buildDeliveryInfoRow(Icons.location_on, 'Pickup Address',
                '${_currentDelivery?.pickupAddress.street}, ${_currentDelivery?.pickupAddress.city}'),
            _buildDeliveryInfoRow(Icons.location_on, 'Delivery Address',
                '${_currentDelivery?.pickupAddress.street}, ${_currentDelivery?.deliveryAddress.city}'),
            _buildDeliveryInfoRow(Icons.access_time, 'Scheduled Time',
                _currentDelivery!.predictedDeliveryTime.toString()),
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

  Widget _buildReadySwitch(DeliveryRouteBloc deliveryRouteBloc) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ready to Deliver?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 30,
          ),
          Switch(
            value: isReady,
            onChanged: (value) {
              _onReadyPressed(deliveryRouteBloc);
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            trackOutlineWidth: WidgetStateProperty.all(0.0),
          ),
        ],
      ),
    );
  }
}
