import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:tarot/widgets/card_widget.dart';

class DrawScreen extends StatelessWidget {
  const DrawScreen({super.key, required this.arguments});

  final DrawScreenArguments arguments;

  static const id = 'draw_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarot Draw')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final flip = Random().nextBool();
                      return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TarotCard(
                                  name: arguments.cards[index].name,
                                  imageSrc: arguments.cards[index].imageSrc,
                                  id: arguments.cards[index].id,
                                  upright: arguments.cards[index].upright,
                                  reversed: arguments.cards[index].reversed,
                                  type: arguments.cards[index].type,
                                  flip: flip))
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 16,);
                    },
                    itemCount: arguments.cards.length)),
          ],
        ),
        // child: Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: arguments.cards.map((card) {
        //         final flip = Random().nextBool();
        //         return Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: TarotCard(
        //             name: card.name,
        //             imageSrc: card.imageSrc,
        //             id: card.id,
        //             upright: card.upright,
        //             reversed: card.reversed,
        //             type: card.type,
        //             flip: flip
        //           ),
        //         );
        //       }).toList(),
        //     )
        //   ],
        // ),
      ),
    );
  }
}

class DrawScreenArguments {
  DrawScreenArguments({required this.cards});

  final List<TarotCardObject> cards;
}
