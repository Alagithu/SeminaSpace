import 'package:flutter/material.dart';
import 'package:flutter_application_1/item_home.dart';
import 'package:flutter_application_1/offer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          OfferPage(),
          Expanded(
            child: ListView(
              children: [ItemHome(), ItemHome2(), ItemHome3(), ItemHome4()],
            ),
          ),
        ],
      ),
    );
  }
}
