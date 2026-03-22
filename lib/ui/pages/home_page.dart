import 'package:flutter/material.dart';
import 'package:location_opinions/services/opinion_service.dart';
import 'package:location_opinions/ui/widgets/opinion_card.dart';
import 'link_email_page.dart';
import 'opinion_creation_page.dart';
import 'settings_page.dart';
import '../../models/opinion.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final opinionService = OpinionService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opinions'),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.person),
          onSelected: (value) {
            if (value == 'link_email') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LinkEmailPage(),
                ),
              );
            } else if (value == 'settings') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'link_email',
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('Link email'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const OpinionCreationPage(),
            ),
          );
        },
        tooltip: 'Share Opinion',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Opinion>>(
        stream: opinionService.getOpinionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final List<Opinion> opinions = (snapshot.data ?? <Opinion>[]);
          if (opinions.isEmpty) {
            return const Center(child: Text('No opinions yet.'));
          }
          return ListView.builder(
            itemCount: opinions.length,
            itemBuilder: (context, index) {
              final opinion = opinions[index];
              return OpinionCard(opinion);
            },
          );
        },
      ),
    );
  }
}
