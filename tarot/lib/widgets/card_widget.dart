import 'package:flutter/material.dart';
import 'package:tarot/card/card_screen.dart';
import 'package:tarot/home/home_screen.dart';

class TarotCard extends StatelessWidget {
  const TarotCard(
      {super.key,
      required this.name,
      required this.imageSrc,
      required this.id,
      required this.type,
      required this.upright,
      required this.reversed,
      this.flip});

  final String name;
  final String imageSrc;

  final String id;
  final String type;
  final String upright;
  final String reversed;
  final bool? flip;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, CardScreen.id,
            arguments: CardScreenArguments(TarotCardObject(
                imageSrc: imageSrc,
                id: id,
                upright: upright,
                reversed: reversed,
                type: type,
                name: name))),
        child: SizedBox(
          width: 200,
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: flip == true ? 2 : 0,
                      child: Image.asset(
                        imageSrc,
                        height: 200,
                      ),
                    ),
                    Text(name),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      color: flip == null || flip == true ? Colors.black : Theme.of(context).primaryColor
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Upright: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: upright),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                        color: flip == null || flip == false ? Colors.black : Theme.of(context).primaryColor
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Reversed: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: reversed),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
