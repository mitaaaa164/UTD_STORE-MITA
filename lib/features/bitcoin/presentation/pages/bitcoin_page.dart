import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BitcoinPage extends StatefulWidget {
  const BitcoinPage({super.key});

  @override
  State<BitcoinPage> createState() => _BitcoinPageState();
}

class _BitcoinPageState extends State<BitcoinPage> {
  final dio = Dio();

  String price = "Loading...";

  Timer? timer;

  @override
  void initState() {
    super.initState();

    getBitcoinPrice();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      getBitcoinPrice();
    });
  }

  Future<void> getBitcoinPrice() async {
    try {
      final response = await dio.get(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd',
      );

      final data = response.data;

      setState(() {
        price = data['bitcoin']['usd'].toString();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

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
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),

            const SizedBox(height: 20),

            const Text(
              "BTC / USD",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "\$ $price",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text("Realtime Update Every 1 Second"),
          ],
        ),
      ),
    );
  }
}
