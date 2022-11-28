import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:tarot/widgets/drawer_widget.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key, required this.arguments});

  final CardScreenArguments arguments;

  static const id = 'card_screen';

  @override
  Widget build(BuildContext context) {
    TarotCardObject card = arguments.card;
    return Scaffold(
        appBar: AppBar(title: Text(card.name.toUpperCase())),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(card.name.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineLarge),
                  Image.asset(
                    card.imageSrc,
                    height: 512,
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Upright: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: card.upright),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Reversed: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: card.reversed),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
class CardScreenArguments{
  CardScreenArguments(this.card);

  final TarotCardObject card;
}