import 'package:flutter/material.dart';

class TarotDrawer extends StatelessWidget {
  const TarotDrawer({super.key, required this.changeType});

  final Function changeType;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 70,
            child: DrawerHeader(
              child: Text(
                'Cards',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Major'),
            onTap: () {
              changeType('major');
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_fix_high),
            title: const Text('Wands'),
            onTap: () {
              changeType('wands');
            },
          ),
          ListTile(
            leading: const Icon(Icons.wine_bar),
            title: const Text('Cups'),
            onTap: () {
              changeType('cups');
            },
          ),
          ListTile(
            leading: const Icon(Icons.scatter_plot),
            title: const Text('Pentables'),
            onTap: () {
              changeType('pentacles');
            },
          ),
          ListTile(
            leading: const Icon(Icons.strikethrough_s),
            title: const Text('Swords'),
            onTap: () {
              changeType('swords');
            },
          ),
        ],
      ),
    );
  }
}