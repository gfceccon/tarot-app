import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:tarot/widgets/app_bar_widget.dart';
import 'package:tarot/widgets/card_widget.dart';
import 'package:tarot/widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const id = 'home_screen';

  @override
  State<HomeScreen> createState() {
    return _HomeScreen();
  }
}

class TarotCardObject {
  TarotCardObject(
      {required this.imageSrc,
      required this.id,
      required this.upright,
      required this.reversed,
      required this.type,
      required this.name});

  final String name;
  final String imageSrc;
  final String id;
  final String upright;
  final String reversed;
  final String type;
}

class _HomeScreen extends State<HomeScreen> {
  final List<Map<String, dynamic>> tarotDeck = [];
  final List<Widget> tarotCards = [];
  final cache = GetStorage();
  var cardType = 'all';

  @override
  void initState() {
    super.initState();

    final String? tarotEncoded = cache.read('tarot');
    if (tarotEncoded != null) {
      print('Cache');
      setState(() {
        final tarotDecoded = (jsonDecode(tarotEncoded) as List<dynamic>)
            .map((cardJson) => cardJson as Map<String, dynamic>)
            .toList();
        tarotDeck.addAll(tarotDecoded);
        filterDeck();
      });
    } else {
      print('API');
      loadCards();
    }
  }

  void loadCards() {
    FirebaseFirestore.instance
        .collection('tarot')
        .get()
        .then((tarotCollection) {
      setState(() {
        tarotDeck.clear();
        tarotDeck.addAll(
            tarotCollection.docs.map((document) => document.data()).toList());
        cache.write('tarot', jsonEncode(tarotDeck));
        filterDeck();
      });
    });
  }

  void filterDeck() {
    var tarotList = tarotDeck
        .where((card) {
          if (cardType == 'all') {
            return true;
          } else {
            return card['type'] == cardType;
          }
        })
        .map((card) => TarotCardObject(
            name: card['name'],
            imageSrc: card['image_src'],
            id: card['id'],
            upright: card['upright'],
            reversed: card['reversed'],
            type: card['type']))
        .toList();

    tarotList.sort((a, b) => a.id.compareTo(b.id));

    tarotCards.clear();
    tarotCards.addAll(tarotList
        .map((card) => TarotCard(
              name: card.name,
              imageSrc: card.imageSrc,
              id: card.id,
              upright: card.upright,
              reversed: card.reversed,
              type: card.type,
            ))
        .toList());
  }

  void changeType(type) {
    if (['all', 'major', 'wands', 'cups', 'pentacles', 'swords']
        .any((element) => element == type)) {
      setState(() {
        cardType = type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TarotAppBar(),
        drawer: TarotDrawer(changeType: changeType),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 100,),
            itemCount: tarotCards.length,
            itemBuilder: (context, index) => tarotCards[index],
          ),
        ));
  }
}
