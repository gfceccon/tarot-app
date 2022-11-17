import 'package:flutter/material.dart';

class TarotCard extends StatelessWidget {
  const TarotCard(
      {super.key,
      required this.name,
      required this.imageSrc,
      required this.id,
      required this.type,
      required this.upright,
      required this.reversed});

  final String name;
  final String imageSrc;

  final String id;
  final String type;
  final String upright;
  final String reversed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imageSrc,
            height: 200,
          ),
          Text(name),
          Row(
            children: [
              const Text('Upright:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(upright),
            ],
          ),
          Row(
            children: [
              const Text('Reversed:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(reversed),
            ],
          ),
        ],
      ),
    );
  }
}
