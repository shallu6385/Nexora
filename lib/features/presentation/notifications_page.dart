import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3EDFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 54,
                  color: Color(0xFF0B3473),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You’re all caught up!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Assignment reminders and important updates '
                'will appear here when notifications are implemented.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
