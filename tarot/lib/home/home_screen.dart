import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:tarot/draw/draw_screen.dart';
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
  final List<Map<String, dynamic>> tarotDeckJson = [];
  final List<TarotCardObject> tarotDeck = [];
  final List<Widget> tarotCards = [];
  final cache = GetStorage();
  var cardType = 'major';

  final cardsToDraw = 3;

  @override
  void initState() {
    super.initState();

    final String? tarotEncoded = cache.read('tarot');
    if (tarotEncoded != null) {
      print('Cache');
      setState(() {
        tarotDeckJson.clear();
        tarotDeckJson.addAll(loadDeckFromCache(tarotEncoded));
        mapDeck();
        filterDeck();
      });
    } else {
      print('API');
      loadDeckFromApi().then((value) {
        setState(() {
          tarotDeckJson.clear();
          tarotDeckJson.addAll(value);
          cache.write('tarot', jsonEncode(tarotDeckJson));
          mapDeck();
          filterDeck();
        });
      });
    }
  }

  void mapDeck() {
    tarotDeck.clear();
    tarotDeck.addAll(tarotDeckJson
        .map((card) => TarotCardObject(
            name: card['name'],
            imageSrc: card['image_src'],
            id: card['id'],
            upright: card['upright'],
            reversed: card['reversed'],
            type: card['type']))
        .toList());
  }

  List<Map<String, dynamic>> loadDeckFromCache(String tarotEncoded) {
    return (jsonDecode(tarotEncoded) as List<dynamic>)
        .map((cardJson) => cardJson as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> loadDeckFromApi() async {
    var tarotCollection =
        await FirebaseFirestore.instance.collection('tarot').get();
    return tarotCollection.docs.map((document) => document.data()).toList();
  }

  void filterDeck() {
    var tarotList = tarotDeck.where((card) {
      if (cardType == 'all') {
        return true;
      } else {
        return card.type == cardType;
      }
    }).toList();

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
        filterDeck();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarot App')),
      drawer: TarotDrawer(changeType: changeType),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Text('${cardType.toUpperCase()} ARCANA',
                style: Theme.of(context).textTheme.headlineLarge),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                itemCount: tarotCards.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: tarotCards[index],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.collections_bookmark_rounded),
          onPressed: () {
            tarotDeck.shuffle(Random());
            Navigator.pushNamed(context, DrawScreen.id,
                arguments: DrawScreenArguments(
                    cards: tarotDeck.sublist(0, cardsToDraw)));
          }),
    );
  }
}
