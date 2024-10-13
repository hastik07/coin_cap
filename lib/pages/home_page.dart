import 'dart:convert';
import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? deviceHeight, deviceWidth;
  String? selectedCoin = "bitcoin";
  HTTPService? http;

  @override
  void initState() {
    super.initState();
    http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              selectedCoinDropdown(),
              dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedCoinDropdown() {
    List<String> coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "ripple",
    ];
    List<DropdownMenuItem<String>> items = coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: selectedCoin,
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 40,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      items: items,
      underline: Container(),
      onChanged: (dynamic value) {
        setState(() {
          selectedCoin = value.toString();
        });
      },
    );
  }

  Widget dataWidgets() {
    return FutureBuilder(
      future: http!.get("/coins/$selectedCoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(
            snapshot.data.toString(),
          );
          Map exchangeRates = data["market_data"]["current_price"];
          num usdPrice = data["market_data"]["current_price"]["usd"];
          num change24h = data["market_data"]["price_change_percentage_24h"];
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        rates: exchangeRates,
                      ),
                    ),
                  );
                },
                child: coinImage(
                  data["image"]["large"],
                ),
              ),
              currentPriceWidget(usdPrice),
              percentageChangeWidget(change24h),
              descriptionCardWidget(
                data["description"]["en"],
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget percentageChangeWidget(num change) {
    return Text(
      "${change.toString()} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget coinImage(String imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight! * 0.02,
      ),
      height: deviceHeight! * 0.15,
      width: deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }

  Widget descriptionCardWidget(String description) {
    return Container(
      height: deviceHeight! * 0.45,
      width: deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight! * 0.01,
        horizontal: deviceHeight! * 0.01,
      ),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        description,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
