import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BitcoinPage extends StatefulWidget {
  const BitcoinPage({super.key});

  @override
  State<BitcoinPage> createState() => _BitcoinPageState();
}

class _BitcoinPageState extends State<BitcoinPage> {
  late WebSocketChannel channel;

  String price = "Loading...";

  @override
  void initState() {
    super.initState();

    connectWebSocket();
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );

    channel.stream.listen(
      (message) {
        final data = jsonDecode(message);

        setState(() {
          price = data['bitcoin'];
        });
      },

      onError: (error) {
        debugPrint(error.toString());
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bitcoin Live Price")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.currency_bitcoin, size: 80, color: Colors.orange),

            const SizedBox(height: 20),

            const Text(
              "BTC Live",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "\$ $price",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
