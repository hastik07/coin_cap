import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;

  const DetailsPage({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    List exchangeRates = rates.values.toList();
    List currencies = rates.keys.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (context, int index) {
            String currency = currencies[index].toString().toUpperCase();
            String exchangeRate = exchangeRates[index].toString();
            return ListTile(
              title: Text(
                "$currency: $exchangeRate",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
